#!/bin/sh

(
    cd ubuntu/3.0 \
    && echo checking update for 1.18-standard-3.0 >&2 \
    && ./update.pl 1.18 \
    && echo checking update for 1.17-standard-3.0 >&2 \
    && ./update.pl 1.17 \
    && true
) || exit 1
(
    cd ubuntu/4.0 \
    && echo checking update for 1.18-standard-4.0 >&2 \
    && ./update.pl 1.18 \
    && echo checking update for 1.17-standard-4.0 >&2 \
    && ./update.pl 1.17 \
    && true
) || exit 1
(
    cd ubuntu/5.0 \
    && echo checking update for 1.18-standard-5.0 >&2 \
    && ./update.pl 1.18 \
    && echo checking update for 1.17-standard-5.0 >&2 \
    && ./update.pl 1.17 \
    && true
) || exit 1
(
    cd al2/2.0 \
    && echo checking update for 1.18-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.18 \
    && echo checking update for 1.17-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.17 \
    && true
) || exit 1
(
    cd al2/3.0 \
    && echo checking update for 1.18-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.18 \
    && echo checking update for 1.17-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.17 \
    && true
) || exit 1
