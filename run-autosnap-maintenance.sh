#!/bin/sh

cd incoming
../autosnap-renamer.sh
../autosnap-mover.sh
cd ..
./autosnap-rsyncer.sh
