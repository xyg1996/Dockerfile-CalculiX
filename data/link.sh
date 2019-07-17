#!/bin/bash

# see for more, http://www.dhondt.de/
[ -n "$1" ]                      && CALCULIX_VERSION=$1
[ -n "$CALCULIX_VERSION" ]       || CALCULIX_VERSION=2.15

# linux binaries
wget "http://www.dhondt.de/cgx_$CALCULIX_VERSION.bz2"

# source code, documentation and examples
wget "http://www.dhondt.de/cgx_$CALCULIX_VERSION.all.tar.bz2"
