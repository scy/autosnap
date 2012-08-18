#!/bin/sh -e

# Change to work directory.
cd "$AUTOSNAPRNIN"

for from in *; do
	# Build a "to" name by fixing the date format and position in file names.
	to="$(echo "$from" | sed -e 's/^autosnap[_-]\([^_-]*\)\.\(..\)\.\(..\)\.\(....\)\.\(..\)\.\(..\)\.\(..\)\.jpg$/\4-\3-\2_\5-\6-\7_autosnap_\1.jpg/' -e 's/^autosnap[_-]\([^_-]*\)\.\(....\)\.\(..\)\.\(..\)\.\(..\)\.\(..\)\.\(..\)\.jpg$/\2-\3-\4_\5-\6-\7_autosnap_\1.jpg/')"
	# If the file name has not changed, there's no sense in renaming it.
	if [ "$from" != "$to" ]; then
		mv "$from" "$to"
	fi
done
