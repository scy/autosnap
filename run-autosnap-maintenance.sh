#!/bin/sh -e

cd incoming
../autosnap-renamer.sh
../autosnap-mover.sh
cd ..
./autosnap-rsyncer.sh
