#!/bin/sh

(
    cd ubuntu/3.0 \
    && echo checking update for 1.20-standard-3.0 >&2 \
    && ./update.pl 1.20 \
    && echo checking update for 1.19-standard-3.0 >&2 \
    && ./update.pl 1.19 \
    && echo checking update for 1.18-standard-3.0 >&2 \
    && ./update.pl 1.18 \
    && true
) || exit 1
(
    cd ubuntu/4.0 \
    && echo checking update for 1.20-standard-4.0 >&2 \
    && ./update.pl 1.20 \
    && echo checking update for 1.19-standard-4.0 >&2 \
    && ./update.pl 1.19 \
    && echo checking update for 1.18-standard-4.0 >&2 \
    && ./update.pl 1.18 \
    && true
) || exit 1
(
    cd ubuntu/5.0 \
    && echo checking update for 1.20-standard-5.0 >&2 \
    && ./update.pl 1.20 \
    && echo checking update for 1.19-standard-5.0 >&2 \
    && ./update.pl 1.19 \
    && echo checking update for 1.18-standard-5.0 >&2 \
    && ./update.pl 1.18 \
    && true
) || exit 1
(
    cd al2/2.0 \
    && echo checking update for 1.20-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.20 \
    && echo checking update for 1.19-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.19 \
    && echo checking update for 1.18-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.18 \
    && true
) || exit 1
(
    cd al2/3.0 \
    && echo checking update for 1.20-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.20 \
    && echo checking update for 1.19-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.19 \
    && echo checking update for 1.18-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.18 \
    && true
) || exit 1
