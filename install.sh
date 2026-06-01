#!/usr/bin/env bash
#
# Dotfiles installer (idempotent, symlink-based).
#
# Usage:
#   ./install.sh           # symlink all dotfiles into $HOME (backs up existing real files)
#   ./install.sh --pull    # `git pull` first, then symlink (keep all machines up to date)
#   ./install.sh --dry-run # show what would happen without touching anything
#
# Machine-local secrets / overrides go in ~/.zshrc.local (never tracked).

set -euo pipefail

# Resolve the directory this script lives in, so it works no matter where the repo is cloned.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

PULL=false
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --pull)    PULL=true ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

# repo-relative path  ->  $HOME-relative target
# (target defaults to the same name under $HOME)
LINKS=(
  ".zshrc"
  ".zprofile"
  ".gitconfig"
  ".gitignore"
  ".vimrc"
  ".gemrc"
  ".pryrc"
  ".tigrc"
  ".peco"
  ".config/nvim"
  ".config/ghostty/config"
)

info()  { printf '\033[0;34m%s\033[0m\n' "$*"; }
ok()    { printf '\033[0;32m%s\033[0m\n' "$*"; }
warn()  { printf '\033[0;33m%s\033[0m\n' "$*"; }

run() {
  if $DRY_RUN; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

if $PULL; then
  info "==> git pull (origin)"
  run git -C "$DOTFILES_DIR" pull --ff-only
fi

info "==> linking dotfiles from $DOTFILES_DIR into $HOME"

link_one() {
  local rel="$1"
  local src="$DOTFILES_DIR/$rel"
  local dst="$HOME/$rel"

  if [[ ! -e "$src" ]]; then
    warn "  skip  $rel (missing in repo)"
    return
  fi

  # Already the correct symlink? nothing to do.
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "  ok    $rel (already linked)"
    return
  fi

  # Ensure parent dir exists (e.g. ~/.config for ~/.config/nvim).
  local parent
  parent="$(dirname "$dst")"
  [[ -d "$parent" ]] || run mkdir -p "$parent"

  # Back up an existing real file/dir (or a stale symlink) before replacing.
  if [[ -e "$dst" || -L "$dst" ]]; then
    run mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    run mv "$dst" "$BACKUP_DIR/$rel"
    warn "  backup $rel -> $BACKUP_DIR/$rel"
  fi

  run ln -s "$src" "$dst"
  ok "  link  $rel -> $src"
}

for rel in "${LINKS[@]}"; do
  link_one "$rel"
done

# Make sure ~/.zshrc.local exists so `source` in .zshrc never errors on a fresh machine.
if [[ ! -e "$HOME/.zshrc.local" ]]; then
  if $DRY_RUN; then
    echo "  [dry-run] create ~/.zshrc.local template"
  else
    cat > "$HOME/.zshrc.local" <<'EOF'
# Machine-local secrets / overrides. NOT tracked by the dotfiles repo.
# e.g. export OPENAI_API_KEY='...'
EOF
    ok "  init  ~/.zshrc.local (machine-local secrets template)"
  fi
fi

info "==> done"
[[ -d "$BACKUP_DIR" ]] && warn "Replaced files were backed up under: $BACKUP_DIR"
echo "Restart your shell or run: source ~/.zshrc"
