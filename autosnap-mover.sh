#!/bin/sh

for from in *; do
	dest="$(echo "$from" | sed -n -e 's/^\(....\)-\(..\)-\(..\)_\(..-..-.._autosnap_[a-zA-Z0-9-]*\.jpg\)$/..\/\1\/\2\/\3\/\1-\2-\3_\4/p')"
	if [ -n "$dest" ]; then
		destdir="$(dirname "$dest")"
		mkdir -p "$destdir" && mv "$from" "$dest"
	fi
done
