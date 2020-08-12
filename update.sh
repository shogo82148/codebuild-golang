#!/bin/sh

(
    cd ubuntu/1.0 \
    && echo checking update for 1.13-standard-1.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-standard-1.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-standard-1.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd ubuntu/2.0 \
    && echo checking update for 1.13-standard-2.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-standard-2.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-standard-2.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd ubuntu/3.0 \
    && echo checking update for 1.13-standard-3.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-standard-3.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-standard-3.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd ubuntu/4.0 \
    && echo checking update for 1.13-standard-4.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-standard-4.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-standard-4.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd al2/1.0 \
    && echo checking update for 1.13-amazonlinux2-1.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-amazonlinux2-1.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-amazonlinux2-1.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd al2/2.0 \
    && echo checking update for 1.13-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-amazonlinux2-2.0 >&2 \
    && ./update.pl 1.15
) || exit 1
(
    cd al2/3.0 \
    && echo checking update for 1.13-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.13 \
    && echo checking update for 1.14-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.14 \
    && echo checking update for 1.15-amazonlinux2-3.0 >&2 \
    && ./update.pl 1.15
) || exit 1
