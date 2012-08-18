#!/bin/sh -e

# Change to "from" directory.
cd "$AUTOSNAPMVFROM"

for from in *; do
	destsubdir="$(echo "$from" | sed -n -e 's/^\(....\)-\(..\)-\(..\)_\(..-..-.._autosnap_[a-zA-Z0-9-]*\.jpg\)$/\1\/\2\/\3/p')"
	# If there was no path returned, the file name did not match the pattern.
	# In that case, do nothing.
	if [ -n "$destsubdir" ]; then
		destdir="$AUTOSNAPMVTO/$destsubdir"
		if [ -e "$destdir" -a ! -d "$destdir" ]; then
			echo "autosnap-mover: $destdir exists and is no directory" >&2
			exit 3
		fi
		mkdir -p "$destdir" && mv "$from" "$destdir"
	fi
done
