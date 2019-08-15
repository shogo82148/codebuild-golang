#!/bin/sh

( cd ubuntu/1.0 && ./update.pl 1.11 && ./update.pl 1.12 )
( cd ubuntu/2.0 && ./update.pl 1.11 && ./update.pl 1.12 )
( cd al2/1.0 && ./update.pl 1.11 && ./update.pl 1.12 )
