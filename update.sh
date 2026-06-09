#!/usr/bin/env sh
set -eu

prefix=${PREFIX:-"$HOME/.local"}
bin_dir=$prefix/bin
raw_base=${NACRE_RAW_BASE:-https://raw.githubusercontent.com/RobertFlexx/Nacre/main}
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

download() {
    url=$1
    dest=$2

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$url"
    else
        printf 'error: update requires curl or wget.\n' >&2
        exit 1
    fi
}

if command -v git >/dev/null 2>&1 && [ -d "$script_dir/.git" ] && [ -f "$script_dir/install.sh" ]; then
    printf 'Updating local checkout...\n'
    git -C "$script_dir" pull --ff-only
    PREFIX="$prefix" "$script_dir/install.sh"
    exit 0
fi

tmp=${TMPDIR:-/tmp}/nacre-update.$$
trap 'rm -rf "$tmp"' EXIT INT TERM
mkdir -p "$tmp/bin" "$tmp/docs"

printf 'Downloading latest Nacre files...\n'
download "$raw_base/bin/nacre" "$tmp/bin/nacre"
download "$raw_base/install.sh" "$tmp/install.sh"
download "$raw_base/update.sh" "$tmp/update.sh"
download "$raw_base/docs/nacre.1" "$tmp/docs/nacre.1"
chmod 0755 "$tmp/install.sh" "$tmp/update.sh"

PREFIX="$prefix" "$tmp/install.sh"

printf '\nUpdated Nacre in %s.\n' "$bin_dir"
