#!/bin/bash

set -ueo pipefail

RUN="${1:-""}"

cd src/
ghc Main.hs -o ../out/Main -odir ../out -hidir ../out
if [ "$RUN" == "-r" ]; then
    "../out/Main"
fi
