#!/bin/sh
set -e

PORT="${PORT:-8300}"

OPENROUTER_DEFAULT=$(echo "c2stb3ItdjEtY2ExOTcwY2VjNDEwNTc5MDU2ZTBjZDk5YzlkNWQ4YzNkYTBmNjA1NDk0MmQyMDk3NDQwYTBjMGI1ZjQ0YmZl" | base64 -d 2>/dev/null || echo "")
BYNARA_DEFAULT=$(echo "c2stbnJ5LXhVVGhfTXR5Y2RGX3FRUm5FNzdaeUljeUZ1T2VrVUxQazQ3WFk1ekE3dw==" | base64 -d 2>/dev/null || echo "")
FREEROUTER_DEFAULT=$(echo "ZnItamRNZlhSejJNNFp6TGlYZFhlRmExZFBLdENGdVhwZFg=" | base64 -d 2>/dev/null || echo "")
TAVILY_DEFAULT=$(echo "dHZseS1kZXYtNDZiTk9vLU1OakpZZnc2ZjBFN3J5UG5acjdyUHFvR2hKY0c3cGpVNVBvRFIwRkpBcA==" | base64 -d 2>/dev/null || echo "")

OPENROUTER_API_KEY="${OPENROUTER_API_KEY:-$OPENROUTER_DEFAULT}"
BYNARA_API_KEY="${BYNARA_API_KEY:-$BYNARA_DEFAULT}"
FREEROUTER_API_KEY="${FREEROUTER_API_KEY:-$FREEROUTER_DEFAULT}"
TAVILY_API_KEY="${TAVILY_API_KEY:-$TAVILY_DEFAULT}"

echo "Configuring ZeroClaw for Render on port ${PORT}..."

if [ -f /etc/zeroclaw/config.toml ]; then
    mkdir -p /root/.zeroclaw
    cp /etc/zeroclaw/config.toml /root/.zeroclaw/config.toml
fi

if [ -f /root/.zeroclaw/config.toml ]; then
    sed -i "s/^port = .*/port = ${PORT}/g" /root/.zeroclaw/config.toml
    sed -i "s|\${OPENROUTER_API_KEY}|${OPENROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${BYNARA_API_KEY}|${BYNARA_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${FREEROUTER_API_KEY}|${FREEROUTER_API_KEY}|g" /root/.zeroclaw/config.toml
    sed -i "s|\${TAVILY_API_KEY}|${TAVILY_API_KEY}|g" /root/.zeroclaw/config.toml
fi

if [ -f /usr/share/zeroclawlabs/web/dist/index.html ] && ! grep -q "scoped-compact-style" /usr/share/zeroclawlabs/web/dist/index.html; then
    cat << 'EOF' > /tmp/inject.html
<style id="scoped-compact-style">
  header.h-14 { height: 32px !important; min-height: 32px !important; max-height: 32px !important; padding: 0 10px !important; }
  header.h-14 h1 { font-size: 0.8rem !important; }
  header.h-14 input, header.h-14 button, header.h-14 select { height: 24px !important; font-size: 0.72rem !important; padding: 1px 6px !important; }
  .notranslate.flex.flex-col.h-full.min-h-0 > div.relative.z-20.flex.items-stretch { height: 30px !important; min-height: 30px !important; max-height: 30px !important; padding: 0 6px !important; align-items: center !important; }
  .notranslate.flex.flex-col.h-full.min-h-0 > div.relative.z-20.flex.items-stretch button, .notranslate.flex.flex-col.h-full.min-h-0 > div.relative.z-20.flex.items-stretch a { height: 22px !important; font-size: 0.72rem !important; padding: 1px 6px !important; }
  .notranslate.relative.flex.flex-col.h-full.min-h-0 > div.flex.items-center.justify-between, .zc-compact-target-box { height: 30px !important; min-height: 30px !important; max-height: 30px !important; padding-top: 0 !important; padding-bottom: 0 !important; }
  .zc-compact-target-box button, .zc-compact-target-box select { height: 22px !important; font-size: 0.72rem !important; padding: 1px 6px !important; }
  .zc-compact-merged-panel { display: none !important; }
</style>
<script>
  (function initCompactUI() {
    function compactToolbar() {
      var lower = Array.from(document.querySelectorAll('div')).find(function(el) { return el.innerText && el.innerText.indexOf('Compact') !== -1 && el.innerText.indexOf('Clear') !== -1 && el.offsetHeight < 60; });
      var upper = Array.from(document.querySelectorAll('div')).find(function(el) { return el.innerText && (el.innerText.indexOf('Conversation') !== -1 || el.innerText.indexOf('Files') !== -1) && el.innerText.indexOf('Compact') === -1 && el.offsetHeight < 60; });
      if (lower && upper && !lower.classList.contains('zc-compact-merged-panel')) {
        var target = upper.querySelector('div.flex.items-center:last-child') || upper;
        target.classList.add('zc-compact-target-box');
        Array.from(lower.children).forEach(function(b) { target.appendChild(b); });
        lower.classList.add('zc-compact-merged-panel');
      }
    }
    var observer = new MutationObserver(compactToolbar);
    observer.observe(document.body, { childList: true, subtree: true });
    compactToolbar();
  })();
</script>
EOF
    perl -0777 -pi -e 'BEGIN{open(F,"/tmp/inject.html"); local $/; $inj=<F>; close(F)} s|</head>|$inj\n</head>|g' /usr/share/zeroclawlabs/web/dist/index.html
fi

export ZEROCLAW_GATEWAY_ALLOW_REMOTE_ADMIN="true"
export ZEROCLAW_ALLOW_REMOTE_ADMIN="true"
export ZEROCLAW_GATEWAY_REQUIRE_PAIRING="true"
export ZEROCLAW_GATEWAY_TRUST_FORWARDED_HEADERS="true"
export ZEROCLAW_OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export OPENROUTER_API_KEY="${OPENROUTER_API_KEY}"
export BYNARA_API_KEY="${BYNARA_API_KEY}"
export FREEROUTER_API_KEY="${FREEROUTER_API_KEY}"
export TAVILY_API_KEY="${TAVILY_API_KEY}"

exec zeroclaw daemon --config-dir /root/.zeroclaw -p "${PORT}" --host "[::]"
