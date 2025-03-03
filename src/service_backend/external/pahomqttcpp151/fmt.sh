#!/bin/bash
#
# Runs clang format over the whole project tree
#

find . -path './externals' -prune -iname '*.h' -o -iname '*.cpp' | xargs clang-format -i

