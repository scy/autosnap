#!/bin/sh

for from in *; do
	to="$(echo "$from" | sed -e 's/^autosnap[_-]\([^_-]*\)\.\(..\)\.\(..\)\.\(....\)\.\(..\)\.\(..\)\.\(..\)\.jpg$/\4-\3-\2_\5-\6-\7_autosnap_\1.jpg/' -e 's/^autosnap[_-]\([^_-]*\)\.\(....\)\.\(..\)\.\(..\)\.\(..\)\.\(..\)\.\(..\)\.jpg$/\2-\3-\4_\5-\6-\7_autosnap_\1.jpg/')"
	if [ "$from" != "$to" ]; then
		mv "$from" "$to"
	fi
done
