#!/usr/bin/env sh
set -eu

prefix=${PREFIX:-"$HOME/.local"}
bin_dir=$prefix/bin
man_dir=$prefix/share/man/man1
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
nacre_src=$script_dir/bin/nacre
update_src=$script_dir/update.sh
man_src=$script_dir/docs/nacre.1
raw_base=${NACRE_RAW_BASE:-https://raw.githubusercontent.com/RobertFlexx/Nacre/main}

need() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'error: required command not found: %s\n' "$1" >&2
        exit 1
    fi
}

need perl
need cp
need mkdir
need chmod

perl -e 'exit($] >= 5.016 ? 0 : 1)' || {
    printf 'error: Nacre requires Perl 5.16 or newer.\n' >&2
    exit 1
}

mkdir -p "$bin_dir"

if [ -f "$nacre_src" ]; then
    cp "$nacre_src" "$bin_dir/nacre"
elif command -v curl >/dev/null 2>&1; then
    curl -fsSL "$raw_base/bin/nacre" -o "$bin_dir/nacre"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$bin_dir/nacre" "$raw_base/bin/nacre"
else
    printf 'error: cannot find local bin/nacre and neither curl nor wget is available.\n' >&2
    exit 1
fi
chmod 0755 "$bin_dir/nacre"

if [ -f "$update_src" ]; then
    cp "$update_src" "$bin_dir/nacre-update"
elif command -v curl >/dev/null 2>&1; then
    curl -fsSL "$raw_base/update.sh" -o "$bin_dir/nacre-update" || rm -f "$bin_dir/nacre-update"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$bin_dir/nacre-update" "$raw_base/update.sh" || rm -f "$bin_dir/nacre-update"
fi

if [ -f "$bin_dir/nacre-update" ]; then
    chmod 0755 "$bin_dir/nacre-update"
fi

if [ -f "$man_src" ]; then
    mkdir -p "$man_dir"
    cp "$man_src" "$man_dir/nacre.1"
elif command -v curl >/dev/null 2>&1; then
    mkdir -p "$man_dir"
    curl -fsSL "$raw_base/docs/nacre.1" -o "$man_dir/nacre.1" || rm -f "$man_dir/nacre.1"
elif command -v wget >/dev/null 2>&1; then
    mkdir -p "$man_dir"
    wget -qO "$man_dir/nacre.1" "$raw_base/docs/nacre.1" || rm -f "$man_dir/nacre.1"
fi

if [ -f "$man_dir/nacre.1" ]; then
    chmod 0644 "$man_dir/nacre.1"
fi

printf 'Nacre installed successfully.\n'
printf '\nInstalled files:\n'
printf '  %s\n' "$bin_dir/nacre"
[ -f "$bin_dir/nacre-update" ] && printf '  %s\n' "$bin_dir/nacre-update"
[ -f "$man_dir/nacre.1" ] && printf '  %s\n' "$man_dir/nacre.1"

case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *)
        printf '\nAdd Nacre to PATH:\n'
        printf '  export PATH="%s:$PATH"\n' "$bin_dir"
        ;;
esac

printf '\nStart the shell with:\n'
printf '  nacre\n'
printf '\nRun a quick check with:\n'
printf '  nacre -c '\''= 2 + 2'\''\n'
