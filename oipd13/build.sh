#!/bin/sh -e

OIPD13DIR="$(dirname "$0")"
TODAYDIR="$1"

# Don't do anything if it's not the #oipd13.
[ "$(date +%Y-%m-%d)" = '2013-01-28' ] || exit 0

cd "$OIPD13DIR"

# Which file was the current one last time we ran?
[ -f lastfile.txt ] && lastfile="$(cat lastfile.txt)"
[ -f "$lastfile" ] || lastfile=''

# Which file is currently the most recent one?
currentfile="$(basename "$(find "$TODAYDIR" -iname '*autosnap*.jpg' | sort | tail -n 1)")"

# If these are the same files, don't do anything.
[ "$lastfile" = "$currentfile" ] && exit 0

# Extract date and host out of the file name.
filedatetime="$(echo "$currentfile" | sed -e 's/^\(....-..-..\)_\(..\)-\(..\)-\(..\)_autosnap_.*$/\1 \2:\3:\4/')"
filehost="$(echo "$currentfile" | sed -e 's/^.*_autosnap_\([^.]*\).*$/\1/')"

# Generate a device name out of the host name.
case "$filehost" in
	crys)
		filedevice='Laptop'
		;;
	leafnode)
		filedevice='Telefon'
		;;
	viewport)
		filedevice='Tablet'
		;;
	*)
		filedevice="„$filehost“"
		;;
esac

# Copy the file over.
cp "$TODAYDIR/$currentfile" .

# Generate a new index.html.
sed \
	-e "/ id=\"photo\" /s/ src=\"[^\"]*\" / src=\"$currentfile\" /g" \
	-e "/<figcaption>/s/YYYY-MM-DD hh:mm:ss/$filedatetime/g" \
	-e "/<figcaption>/s/DEVICE/$filedevice/g" \
	oipd13.html > index.html

# Store last file.
echo "$currentfile" > lastfile.txt

# rsync all that stuff over.
rsync -4rtl --del ./ scy@eridanus.uberspace.de:www/scytale.name/proj/oipd13
