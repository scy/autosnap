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
elif which mplayer >/dev/null 2>&1; then
	tmp=$(mktemp -d)
	cd $tmp
	mplayer -msglevel all=0 -vo jpeg -frames 20 tv://
	mv 00000020.jpg $outfile
	cd
	rm -rf $tmp
else
	die 2 "cannot find imagesnap, fswebcam or mplayer in $PATH"
fi
