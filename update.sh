#!/bin/sh

(
    cd ubuntu/3.0 \
    && echo checking update for 1.24-standard-3.0 >&2 \
    && ./update.pl 1.24 \
    && echo checking update for 1.23-standard-3.0 >&2 \
    && ./update.pl 1.23 \
    && true
) || exit 1
(
    cd ubuntu/4.0 \
    && echo checking update for 1.24-standard-4.0 >&2 \
    && ./update.pl 1.24 \
    && echo checking update for 1.23-standard-4.0 >&2 \
    && ./update.pl 1.23 \
    && true
) || exit 1
(
    cd ubuntu/5.0 \
    && echo checking update for 1.24-standard-5.0 >&2 \
    && ./update.pl 1.24 \
    && echo checking update for 1.23-standard-5.0 >&2 \
    && ./update.pl 1.23 \
    && true
) || exit 1
(
    cd al2/2.0 \
    && echo checking update for 1.24-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.24 \
    && echo checking update for 1.23-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.23 \
    && true
) || exit 1
(
    cd al2/3.0 \
    && echo checking update for 1.24-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.24 \
    && echo checking update for 1.23-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.23 \
    && true
) || exit 1
