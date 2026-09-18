/* 🐺 LXR-ME — draw loop | © 2026 iBoss21 / LXRCore */
(function () {
  const layer = document.getElementById('layer');
  const nodes = new Map();
  let kinds = {};
  let gap = 22;
  let shadow = true;

  function applyStyle(style, display) {
    const r = document.documentElement.style;
    if (style.font) r.setProperty('--font', style.font);
    if (style.fontSizePx) r.setProperty('--size', style.fontSizePx + 'px');
    if (style.radiusPx != null) r.setProperty('--radius', style.radiusPx + 'px');
    if (display && display.fadeMs) r.setProperty('--fade', display.fadeMs + 'ms');
    if (display && display.stackGapPx) gap = display.stackGapPx;
    kinds = style.kinds || {};
    shadow = style.shadow !== false;
  }

  function make(it) {
    const el = document.createElement('div');
    const k = kinds[it.kind] || kinds.me || {};
    el.className = 'me kind-' + String(it.kind || 'me').replace(/[^a-z]/g, '') + (k.italic ? ' italic' : '');
    el.textContent = (k.prefix || '') + it.text;
    layer.appendChild(el);
    return el;
  }

  window.addEventListener('message', (e) => {
    const d = e.data || {};
    if (d.action === 'style') { applyStyle(d.style || {}, d.display || {}); return; }
    if (d.action !== 'draw') return;
    const seen = new Set();
    for (const it of d.items || []) {
      seen.add(it.id);
      let el = nodes.get(it.id);
      if (!el) { el = make(it); nodes.set(it.id, el); }
      const scale = it.scale || 1;
      el.style.left = (it.x * 100) + 'vw';
      el.style.top = `calc(${it.y * 100}vh - ${(it.stack || 0) * gap * scale}px)`;
      el.style.transform = `translate(-50%, -50%) scale(${scale})`;
      if (it.dying) el.classList.add('dying');
    }
    for (const [id, el] of nodes) { if (!seen.has(id)) { el.remove(); nodes.delete(id); } }
  });
})();
