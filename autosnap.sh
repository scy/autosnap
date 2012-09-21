#!/bin/sh

# Output directory.
outdir="$HOME/Dropbox/autosnap/incoming"

# Helps finding a Homebrew-installed imagesnap.
PATH="$PATH:/usr/local/bin"

die() {
	rc="$1"
	shift
	echo autosnap: "$@" >&2
	exit "$rc"
}

if ! which imagesnap >/dev/null 2>&1; then
	die 2 "cannot find imagesnap in $PATH"
fi

if [ ! -d "$outdir" ]; then
	die 3 "outdir is not a directory: $outdir"
fi

imagesnap "$outdir/$(date '+%Y-%m-%d_%H-%M-%S')_autosnap_$(hostname -s).jpg"
