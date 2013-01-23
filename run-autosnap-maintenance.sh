#!/bin/sh -e

# This is the main script to run. Pass the directory it should run in as first parameter.

if [ "$#" -lt 1 -o "$#" -gt 2 ]; then
	echo 'usage: run-autosnap-maintenance.sh DIRECTORY [ARCHDIR]' >&2
	echo '  DIRECTORY is the base autosnap directory where incoming/, today/ etc reside.' >&2
	echo '  ARCHDIR is the directory where 2012/ etc reside. If omitted, defaults to DIRECTORY.' >&2
	echo '  Please note that currently, directories should really be absolute paths.' >&2
	exit 1
fi

export AUTOSNAPDIR="$1"

if [ ! -d "$AUTOSNAPDIR" ]; then
	echo "$AUTOSNAPDIR is not a directory" >&2
	exit 2
fi

export ARCHDIR="$AUTOSNAPDIR"
if [ "$#" -ge 2 ]; then
	export ARCHDIR="$2"
	if [ ! -d "$ARCHDIR" ]; then
		echo "$ARCHDIR is not a directory" >&2
		exit 2
	fi
fi

# Change to the directory we're running from.
cd "$(dirname "$0")"

# Start the renamer.
AUTOSNAPRNIN="$AUTOSNAPDIR/incoming" ./autosnap-renamer.sh

# Start the mover.
AUTOSNAPMVFROM="$AUTOSNAPDIR/incoming" AUTOSNAPMVTO="$ARCHDIR" ./autosnap-mover.sh

# Start the rsyncer.
AUTOSNAPSYNCFROM="$ARCHDIR" AUTOSNAPSYNCTO="$AUTOSNAPDIR/today" ./autosnap-rsyncer.sh
