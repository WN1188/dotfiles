#!/usr/bin/env bash
# Link VS Code user config from this repo and install listed extensions. Safe to re-run.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.config/Code/User"
mkdir -p "$dest"
for f in settings.json keybindings.json; do
  [[ -f "$here/vscode/$f" ]] || continue
  if [[ -e "$dest/$f" && ! -L "$dest/$f" ]]; then mv "$dest/$f" "$dest/$f.bak"; fi
  ln -sfn "$here/vscode/$f" "$dest/$f"
done
installed="$(code --list-extensions)"
while read -r ext; do
  [[ -z "$ext" ]] && continue
  grep -qxi "$ext" <<<"$installed" || code --install-extension "$ext"
done < "$here/vscode/extensions.txt"
