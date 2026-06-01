# dotfiles

Personal dotfiles, distributed via symlinks so every machine stays in sync with this repo.

## Install (existing or new machine)

```bash
# new machine: clone first
git clone https://github.com/reizist/dotfiles.git ~/dotfiles

# one command — symlinks everything into $HOME (existing real files are backed up)
~/dotfiles/install.sh
```

Keep a machine up to date (pull latest, then re-link):

```bash
~/dotfiles/install.sh --pull
```

Preview without changing anything:

```bash
~/dotfiles/install.sh --dry-run
```

## How it works

`install.sh` symlinks each tracked dotfile into `$HOME` (e.g. `~/.zshrc -> ~/dotfiles/.zshrc`).
Because they are symlinks, editing a file at home edits the repo file directly, and a
`git pull` on any machine instantly updates every profile. The script is idempotent: existing
real files are moved to `~/.dotfiles_backup/<timestamp>/` before being replaced.

Tracked: `.zshrc` `.zprofile` `.gitconfig` `.gitignore` `.vimrc` `.gemrc` `.pryrc` `.tigrc`
`.peco/` `.config/nvim/`.

## Machine-local secrets

Anything machine-specific or secret (API keys, etc.) goes in `~/.zshrc.local`, which is **not**
tracked by this repo. `.zshrc` sources it automatically if present. `install.sh` creates an empty
template on a fresh machine.

```bash
# ~/.zshrc.local
export OPENAI_API_KEY='...'
```
