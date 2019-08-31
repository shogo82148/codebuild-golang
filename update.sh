#!/bin/sh

(
    cd ubuntu/1.0 \
    && echo checking update for 1.11-standard-1.0 >&2 \
    && ./update.pl 1.11 \
    && echo checking update for 1.12-standard-1.0 >&2 \
    && ./update.pl 1.12
)
(
    cd ubuntu/2.0 \
    && echo checking update for 1.11-standard-2.0 >&2 \
    && ./update.pl 1.11 \
    && echo checking update for 1.12-standard-2.0 >&2 \
    && ./update.pl 1.12
)
(
    cd al2/1.0 \
    && echo checking update for 1.11-amazonlinux2-1.0 >&2 \
    && ./update.pl 1.11 \
    && echo checking update for 1.12-amazonlinux2-1.0 >&2 \
    && ./update.pl 1.12
)
