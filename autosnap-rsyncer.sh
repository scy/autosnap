#!/bin/sh -e

# Change to the "from" directory.
cd "$AUTOSNAPSYNCFROM"

todaydir="$(date +%Y/%m/%d)"

if [ -d "$todaydir" ]; then
	rsync -rtlv --del --exclude '/.dropbox' --exclude '/Icon?' "$todaydir/" "$AUTOSNAPSYNCTO"
	# Run the oipd13 generator.
	"$OIPD13DIR/build.sh" "$AUTOSNAPSYNCTO"
fi
