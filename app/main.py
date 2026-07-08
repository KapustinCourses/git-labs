from __future__ import annotations

import asyncio
import fcntl
import hashlib
import json
import os
import pty
import re
import shutil
import struct
import subprocess
import tempfile
import termios
import uuid
from pathlib import Path
from typing import Any

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles

LABS_DIR = Path("/labs")
STATIC_DIR = Path("/app/static")

app = FastAPI()

_labs_index: list[dict] = []


def _load_labs() -> None:
    idx = LABS_DIR / "index.json"
    if idx.is_file():
        _labs_index.extend(json.loads(idx.read_text()))


@app.on_event("startup")
async def _startup() -> None:
    _load_labs()


class Session:
    def __init__(self) -> None:
        self.session_id = str(uuid.uuid4())
        self.lab_id: str | None = None
        self.workdir: str | None = None
        self.home: str | None = None
        self.base: str | None = None
        self.master_fd: int | None = None
        self.process: subprocess.Popen | None = None
        self._lock = asyncio.Lock()

    def _kill(self) -> None:
        if self.process:
            try:
                self.process.kill()
                self.process.wait(timeout=2)
            except Exception:
                pass
            self.process = None
        if self.master_fd is not None:
            try:
                os.close(self.master_fd)
            except OSError:
                pass
            self.master_fd = None

    def start_lab(self, lab_id: str) -> str:
        self._kill()
        if self.base and os.path.isdir(self.base):
            shutil.rmtree(self.base, ignore_errors=True)

        base = tempfile.mkdtemp(prefix=f"lab-{lab_id}-")
        home = os.path.join(base, "home")
        repo = os.path.join(base, "repo")
        os.makedirs(home, exist_ok=True)
        os.makedirs(repo, exist_ok=True)
        with open(os.path.join(home, ".gitconfig"), "w", encoding="utf-8") as fh:
            fh.write("[user]\n\tname = Student\n\temail = student@stepik.local\n"
                     "[init]\n\tdefaultBranch = main\n"
                     "[core]\n\teditor = nano\n")

        self.base = base
        self.home = home
        self.workdir = repo
        self.lab_id = lab_id
        lab_env = {**os.environ, "HOME": home, "TMPDIR": home}

        setup = LABS_DIR / lab_id / "setup.sh"
        if setup.is_file():
            marker = "___LAB_ENV_DUMP___"
            res = subprocess.run(
                ["bash", "-c", f'set +e; source "{setup}"; echo "{marker}"; export -p'],
                cwd=repo, env=lab_env, capture_output=True, text=True, timeout=15,
            )
            dump = res.stdout.split(marker, 1)[1] if marker in res.stdout else ""
            base_keys = set(lab_env) | {"SHLVL", "PWD", "OLDPWD", "_", "SHELL", "PATH"}
            env_lines = []
            for line in dump.splitlines():
                m = re.match(r'declare -x ([A-Za-z_][A-Za-z0-9_]*)=(.*)$', line)
                if m and m.group(1) not in base_keys:
                    env_lines.append(f"export {m.group(1)}={m.group(2)}")
            if env_lines:
                with open(os.path.join(home, ".lab_env"), "w", encoding="utf-8") as fh:
                    fh.write("\n".join(env_lines) + "\n")
                with open(os.path.join(home, ".bash_profile"), "w", encoding="utf-8") as fh:
                    fh.write('[ -f ~/.lab_env ] && source ~/.lab_env\n')
                with open(os.path.join(home, ".bashrc"), "a", encoding="utf-8") as fh:
                    fh.write('[ -f ~/.lab_env ] && source ~/.lab_env\n')

        master_fd, slave_fd = pty.openpty()
        process = subprocess.Popen(
            ["/bin/bash", "--login"],
            stdin=slave_fd, stdout=slave_fd, stderr=slave_fd,
            cwd=repo,
            env={
                **lab_env,
                "TERM": "xterm-256color",
                "PS1": r"\[\033[32m\]\u@git-lab\[\033[0m\]:\[\033[34m\]\w\[\033[0m\]\$ ",
            },
            preexec_fn=os.setsid,
            close_fds=True,
        )
        os.close(slave_fd)

        fl = fcntl.fcntl(master_fd, fcntl.F_GETFL)
        fcntl.fcntl(master_fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

        self.master_fd = master_fd
        self.process = process
        return repo

    def resize(self, rows: int, cols: int) -> None:
        if self.master_fd is not None:
            winsize = struct.pack("HHHH", rows, cols, 0, 0)
            fcntl.ioctl(self.master_fd, termios.TIOCSWINSZ, winsize)

    def run_verify(self) -> tuple[str, str]:
        if not self.lab_id or not self.workdir:
            return "", ""
        verify = LABS_DIR / self.lab_id / "verify.sh"
        if not verify.is_file():
            return "no verify.sh", ""
        result = subprocess.run(
            ["bash", "-c",
             f'[ -f "$HOME/.lab_env" ] && source "$HOME/.lab_env"; exec bash "{verify}"'],
            capture_output=True, text=True,
            cwd=self.workdir,
            env={**os.environ, "HOME": self.home or self.workdir},
            timeout=10,
        )
        output = result.stdout
        code = hashlib.sha256(output.encode()).hexdigest()[:8]
        return output, code


_sessions: dict[str, Session] = {}


@app.get("/api/labs")
def get_labs() -> list[dict]:
    return [
        {
            "id": lab["id"],
            "module": lab["module"],
            "module_title": lab["module_title"],
            "lesson": lab["lesson"],
            "lesson_title": lab["lesson_title"],
            "step": lab["step"],
            "title": lab["title"],
        }
        for lab in _labs_index
    ]


def _lab_by_id(lab_id: str | None) -> dict | None:
    if not lab_id:
        return None
    for lab in _labs_index:
        if lab["id"] == lab_id:
            return lab
    return None


@app.get("/api/labs/{lab_id}")
def get_lab(lab_id: str) -> JSONResponse:
    lab = _lab_by_id(lab_id)
    if lab is not None:
        return JSONResponse(lab)
    return JSONResponse({"error": "not found"}, status_code=404)


@app.post("/api/session")
def create_session() -> dict:
    s = Session()
    _sessions[s.session_id] = s
    return {"session_id": s.session_id}


@app.post("/api/session/{session_id}/lab/{lab_id}")
def switch_lab(session_id: str, lab_id: str) -> dict:
    s = _sessions.get(session_id)
    if not s:
        return JSONResponse({"error": "session not found"}, status_code=404)
    workdir = s.start_lab(lab_id)
    return {"ok": True, "workdir": workdir, "lab_id": lab_id}


@app.post("/api/session/{session_id}/verify")
def verify(session_id: str) -> dict:
    s = _sessions.get(session_id)
    if not s:
        return JSONResponse({"error": "session not found"}, status_code=404)
    output, code = s.run_verify()

    lab = _lab_by_id(s.lab_id)
    expected = lab.get("verify_code") if lab else None
    solved = expected is not None and code == expected
    if solved:
        return {"solved": True, "output": output, "verify_code": code}
    return {
        "solved": False,
        "output": output,
        "expected_output": lab.get("expected_output") if lab else None,
    }


@app.websocket("/api/session/{session_id}/terminal")
async def ws_terminal(websocket: WebSocket, session_id: str) -> None:
    await websocket.accept()
    s = _sessions.get(session_id)
    if not s or s.master_fd is None:
        await websocket.close(code=4004, reason="No active terminal")
        return

    master_fd = s.master_fd
    loop = asyncio.get_event_loop()

    async def pty_to_ws() -> None:
        while True:
            try:
                data = await loop.run_in_executor(None, _read_nonblock, master_fd)
                if data:
                    await websocket.send_bytes(data)
                else:
                    await asyncio.sleep(0.01)
            except OSError:
                break
            except Exception:
                break

    async def ws_to_pty() -> None:
        try:
            while True:
                message = await websocket.receive()
                if message.get("type") == "websocket.disconnect":
                    break
                text = message.get("text")
                if text is not None:
                    try:
                        msg: dict[str, Any] = json.loads(text)
                        if msg.get("type") == "resize":
                            s.resize(int(msg["rows"]), int(msg["cols"]))
                    except (json.JSONDecodeError, KeyError, TypeError, ValueError):
                        pass
                    continue
                data = message.get("bytes")
                if data:
                    try:
                        os.write(master_fd, data)
                    except OSError:
                        break
        except (WebSocketDisconnect, RuntimeError):
            pass

    await asyncio.gather(pty_to_ws(), ws_to_pty())


def _read_nonblock(fd: int, size: int = 4096) -> bytes:
    try:
        return os.read(fd, size)
    except BlockingIOError:
        return b""


@app.get("/")
def index() -> FileResponse:
    return FileResponse(STATIC_DIR / "index.html")


app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")
