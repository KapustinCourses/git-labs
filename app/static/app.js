'use strict';

const state = {
  sessionId: localStorage.getItem('git_playground_session') || null,
  currentLabId: null,
  labs: [],
  doneLabs: new Set(JSON.parse(localStorage.getItem('git_playground_done') || '[]')),
  collapsed: new Set(JSON.parse(localStorage.getItem('git_playground_collapsed') || '[]')),
};

function saveCollapsed() {
  localStorage.setItem('git_playground_collapsed', JSON.stringify([...state.collapsed]));
}

const TERM_THEMES = {
  dark: {
    background: '#090c11', foreground: '#d7dce4',
    cursor: '#f0612e', cursorAccent: '#090c11', selectionBackground: '#2c3543',
    black: '#0b0e13', brightBlack: '#5a6573',
    red: '#e8705f', green: '#54d186', yellow: '#d8b34a',
    blue: '#6fa8e6', magenta: '#bd93d6', cyan: '#5ec9c9', white: '#d7dce4',
    brightRed: '#ff7846', brightGreen: '#7ee0a3', brightYellow: '#e8c96a',
    brightBlue: '#8fbdf2', brightMagenta: '#cda8e2', brightCyan: '#7adada', brightWhite: '#ffffff',
  },
  light: {
    background: '#f4f1ea', foreground: '#2a2d33',
    cursor: '#d9501c', cursorAccent: '#f4f1ea', selectionBackground: '#ddd5c4',
    black: '#2a2d33', brightBlack: '#9b9484',
    red: '#c4452f', green: '#2f9e54', yellow: '#b07d18',
    blue: '#2f6bb0', magenta: '#8a4fa8', cyan: '#2f8f8f', white: '#5d6470',
    brightRed: '#d9501c', brightGreen: '#36b863', brightYellow: '#c08a1c',
    brightBlue: '#3a7cc4', brightMagenta: '#9d5cbd', brightCyan: '#359f9f', brightWhite: '#111317',
  },
};

const currentTheme = () => document.documentElement.dataset.theme === 'light' ? 'light' : 'dark';

const term = new Terminal({
  theme: TERM_THEMES[currentTheme()],
  fontFamily: "'IBM Plex Mono', 'JetBrains Mono', 'Cascadia Code', ui-monospace, monospace",
  fontSize: 13,
  lineHeight: 1.3,
  cursorBlink: true,
  allowProposedApi: true,
});

const fitAddon = new FitAddon.FitAddon();
term.loadAddon(fitAddon);

let ws = null;
let termReady = false;

function initTerm() {
  term.open(document.getElementById('terminalContainer'));
  fitAddon.fit();
  termReady = true;
  term.writeln('\x1b[38;5;245mВыберите задание из списка слева, чтобы открыть терминал.\x1b[0m');

  window.addEventListener('resize', () => fitAddon.fit());
  new ResizeObserver(() => { if (termReady) fitAddon.fit(); })
    .observe(document.getElementById('termSection'));

  term.onData(data => {
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(new TextEncoder().encode(data));
    }
  });

  term.onResize(({ cols, rows }) => {
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({ type: 'resize', rows, cols }));
    }
  });
}

function connectTerminalWs() {
  if (ws) { ws.close(); ws = null; }
  if (!state.sessionId) return;

  const proto = location.protocol === 'https:' ? 'wss' : 'ws';
  ws = new WebSocket(`${proto}://${location.host}/api/session/${state.sessionId}/terminal`);
  ws.binaryType = 'arraybuffer';

  ws.onmessage = e => term.write(new Uint8Array(e.data));
  ws.onerror = () => term.writeln('\x1b[31m[Ошибка соединения с терминалом]\x1b[0m');

  ws.onopen = () => {
    fitAddon.fit();
    const { cols, rows } = term;
    ws.send(JSON.stringify({ type: 'resize', rows, cols }));
  };
}

async function ensureSession() {
  if (state.sessionId) {
    return;
  }
  const res = await fetch('/api/session', { method: 'POST' });
  const data = await res.json();
  state.sessionId = data.session_id;
  localStorage.setItem('git_playground_session', state.sessionId);
}

async function loadLabs() {
  const res = await fetch('/api/labs');
  state.labs = await res.json();
  renderSidebar(state.labs);
}

function lessonKey(lab) {
  return `${lab.module}.${lab.lesson}`;
}

function renderSidebar(labs) {
  const list = document.getElementById('labList');
  list.innerHTML = '';

  if (!labs.length) {
    const hint = document.createElement('div');
    hint.className = 'empty-hint';
    hint.textContent = 'Ничего не найдено';
    list.appendChild(hint);
    return;
  }

  const modules = new Map();
  for (const lab of labs) {
    if (!modules.has(lab.module)) {
      modules.set(lab.module, { title: lab.module_title, lessons: new Map() });
    }
    const mod = modules.get(lab.module);
    if (!mod.lessons.has(lab.lesson)) {
      mod.lessons.set(lab.lesson, { title: lab.lesson_title, labs: [] });
    }
    mod.lessons.get(lab.lesson).labs.push(lab);
  }

  const sortedModules = [...modules.entries()].sort((a, b) => a[0] - b[0]);
  for (const [modNum, mod] of sortedModules) {
    const modHeader = document.createElement('div');
    modHeader.className = 'module-header';
    modHeader.textContent = `Модуль ${modNum}. ${mod.title}`;
    list.appendChild(modHeader);

    const sortedLessons = [...mod.lessons.entries()].sort((a, b) => a[0] - b[0]);
    for (const [lesNum, lesson] of sortedLessons) {
      const key = `${modNum}.${lesNum}`;
      const group = document.createElement('div');
      group.className = 'lesson-group' + (state.collapsed.has(key) ? ' collapsed' : '');

      const lh = document.createElement('div');
      lh.className = 'lesson-header';
      lh.innerHTML =
        `<span class="lesson-caret"></span>` +
        `<span class="lesson-title-text">Урок ${lesNum}. ${lesson.title}</span>` +
        `<span class="lesson-count">${lesson.labs.length}</span>`;
      lh.addEventListener('click', () => {
        group.classList.toggle('collapsed');
        if (group.classList.contains('collapsed')) state.collapsed.add(key);
        else state.collapsed.delete(key);
        saveCollapsed();
      });
      group.appendChild(lh);

      const labsWrap = document.createElement('div');
      labsWrap.className = 'lesson-labs';
      for (const lab of lesson.labs) {
        const item = document.createElement('div');
        const done = state.doneLabs.has(lab.id);
        item.className = 'lab-item' + (done ? ' done' : '') +
          (lab.id === state.currentLabId ? ' active' : '');
        item.dataset.labId = lab.id;
        const icon = done ? '✓' : '○';
        item.innerHTML =
          `<span class="lab-status">${icon}</span>` +
          `<span class="lab-text">${escapeHtml(lab.title)}</span>`;
        item.addEventListener('click', () => selectLab(lab.id));
        labsWrap.appendChild(item);
      }
      group.appendChild(labsWrap);
      list.appendChild(group);
    }
  }
}

function escapeHtml(s) {
  return s.replace(/[&<>"]/g, c =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
}

function setActiveItem(labId) {
  document.querySelectorAll('.lab-item').forEach(el =>
    el.classList.toggle('active', el.dataset.labId === labId));
}

async function selectLab(labId) {
  await ensureSession();
  setActiveItem(labId);

  const res = await fetch(`/api/labs/${labId}`);
  const lab = await res.json();

  document.getElementById('currentLabTitle').textContent =
    `Модуль ${lab.module} · Урок ${lab.lesson} — ${lab.title}`;
  document.getElementById('descContent').innerHTML = lab.description_html || '';

  document.getElementById('verifyBar').classList.remove('hidden');
  document.getElementById('verifyResult').classList.add('hidden');
  document.getElementById('verifyFail').classList.add('hidden');
  document.getElementById('btnReset').disabled = false;

  state.currentLabId = labId;
  let startRes = await fetch(`/api/session/${state.sessionId}/lab/${labId}`, { method: 'POST' });
  if (startRes.status === 404) {
    state.sessionId = null;
    localStorage.removeItem('git_playground_session');
    await ensureSession();
    startRes = await fetch(`/api/session/${state.sessionId}/lab/${labId}`, { method: 'POST' });
  }
  connectTerminalWs();
}

document.getElementById('btnVerify').addEventListener('click', async () => {
  if (!state.sessionId || !state.currentLabId) return;
  const res = await fetch(`/api/session/${state.sessionId}/verify`, { method: 'POST' });
  const data = await res.json();

  const resultEl = document.getElementById('verifyResult');
  const failEl = document.getElementById('verifyFail');

  if (data.solved) {
    document.getElementById('verifyCode').textContent = data.verify_code;
    resultEl.classList.remove('hidden');
    failEl.classList.add('hidden');
    state.doneLabs.add(state.currentLabId);
    localStorage.setItem('git_playground_done', JSON.stringify([...state.doneLabs]));
    renderSidebar(state.labs);
  } else {
    resultEl.classList.add('hidden');
    failEl.classList.remove('hidden');
  }

  term.writeln('\r\n\x1b[38;5;245m── вывод проверки ──\x1b[0m');
  term.writeln((data.output || '(пусто)').replace(/\n/g, '\r\n'));
  if (!data.solved && data.expected_output) {
    term.writeln('\x1b[38;5;245m── ожидалось ──\x1b[0m');
    term.writeln(data.expected_output.replace(/\n/g, '\r\n'));
  }
  term.writeln('\x1b[38;5;245m────────────────────\x1b[0m');
});

document.getElementById('btnCopy').addEventListener('click', () => {
  const btn = document.getElementById('btnCopy');
  const code = document.getElementById('verifyCode').textContent;
  const flash = () => {
    btn.textContent = 'Скопировано';
    btn.classList.add('copied');
    setTimeout(() => { btn.textContent = 'Копировать'; btn.classList.remove('copied'); }, 1500);
  };
  navigator.clipboard.writeText(code).then(flash).catch(() => prompt('Скопируйте код:', code));
});

document.getElementById('btnReset').addEventListener('click', async () => {
  if (!state.currentLabId) return;
  if (!confirm('Сбросить лабу к начальному состоянию? Все изменения будут потеряны.')) return;
  await selectLab(state.currentLabId);
});

document.getElementById('btnTheme').addEventListener('click', () => {
  const next = currentTheme() === 'light' ? 'dark' : 'light';
  document.documentElement.dataset.theme = next;
  localStorage.setItem('git_playground_theme', next);
  term.options.theme = TERM_THEMES[next];
});

document.getElementById('searchInput').addEventListener('input', e => {
  const q = e.target.value.toLowerCase().trim();
  if (!q) { renderSidebar(state.labs); return; }
  const filtered = state.labs.filter(
    l => l.title.toLowerCase().includes(q) ||
         l.module_title.toLowerCase().includes(q) ||
         l.lesson_title.toLowerCase().includes(q)
  );
  renderSidebar(filtered);
});

initTerm();
loadLabs();
