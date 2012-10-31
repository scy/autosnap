#!/bin/sh

# Output directory.
outdir="${1:-$HOME/Dropbox/autosnap/incoming}"

# Helps finding a Homebrew-installed imagesnap.
PATH="$PATH:/usr/local/bin"

die() {
	rc="$1"
	shift
	echo autosnap: "$@" >&2
	exit "$rc"
}

if [ ! -d "$outdir" ]; then
	die 3 "outdir is not a directory: $outdir"
fi

outfile="$outdir/$(date '+%Y-%m-%d_%H-%M-%S')_autosnap_$(hostname -s).jpg"

if which imagesnap >/dev/null 2>&1; then
	imagesnap "$outfile"
elif which fswebcam >/dev/null 2>&1; then
	fswebcam --delay 2 --frames 1 --jpeg 90 --no-banner "$outfile"
else
	die 2 "cannot find imagesnap or fswebcam in $PATH"
fi
