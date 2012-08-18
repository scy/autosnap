#!/bin/sh

todaydir="$(date +%Y/%m/%d)"

if [ -d "$todaydir" ]; then
	rsync -rtlv --del --exclude '/.dropbox' --exclude '/Icon?' "$todaydir/" 'today'
fi
