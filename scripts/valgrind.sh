#!/bin/sh
exec valgrind -v --suppressions="../assets/valgrind.supp" \
    --leak-check=full \
    --show-leak-kinds=all \
    --track-origins=yes \
    --num-callers=20 \
    --tool=memcheck -- "$@"
