#!/bin/sh -e

# This is the main script to run. Pass the directory it should run in as first parameter.

if [ "$#" -ne 1 ]; then
	echo 'usage: run-autosnap-maintenance.sh DIRECTORY' >&2
	echo '  DIRECTORY is the base autosnap directory where incoming/, 2012/ etc reside.' >&2
	echo '  Please note that currently, DIRECTORY should really be an absolute path.' >&2
	exit 1
fi

export AUTOSNAPDIR="$1"

if [ ! -d "$AUTOSNAPDIR" ]; then
	echo "$AUTOSNAPDIR is not a directory" >&2
	exit 2
fi

# Start the renamer.
AUTOSNAPRNIN="$AUTOSNAPDIR/incoming" ./autosnap-renamer.sh

# Start the mover.
AUTOSNAPMVFROM="$AUTOSNAPDIR/incoming" AUTOSNAPMVTO="$AUTOSNAPDIR" ./autosnap-mover.sh

# Start the rsyncer.
AUTOSNAPSYNCFROM="$AUTOSNAPDIR" AUTOSNAPSYNCTO="$AUTOSNAPDIR/today" ./autosnap-rsyncer.sh
