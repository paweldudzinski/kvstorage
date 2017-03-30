#!/bin/sh
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname kvstorage_dev \
    -s kvstorage \
    -s reloader
