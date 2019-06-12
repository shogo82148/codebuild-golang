#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use JSON qw(decode_json encode_json);

my $golang = shift or die "golang version is required";

my @versions;
my $pageToken = "";

do {
    my $body = `curl -fsSL "https://www.googleapis.com/storage/v1/b/golang/o?fields=nextPageToken,items%2Fname&pageToken=$pageToken"`;
    my $json = decode_json($body);
    push @versions, map {
        $_->{name} =~ /^go([.0-9]*)[.]src[.]tar[.]gz$/ ? ($1) : ()
    } @{$json->{items}};
    $pageToken = $json->{nextPageToken};
} while($pageToken);

@versions = grep /^$golang[.]?/, sort {
    my @a = split /[.]/, $a;
    my @b = split /[.]/, $b;
    return ($a[0]||0) <=> ($b[0]||0) if ($a[0]||0) != ($b[0]||0);
    return ($a[1]||0) <=> ($b[1]||0) if ($a[1]||0) != ($b[1]||0);
    return ($a[2]||0) <=> ($b[2]||0) if ($a[2]||0) != ($b[2]||0);
    return 0;
} @versions;
my $latest = pop @versions;
my $sha256 = `curl -fsSL "https://storage.googleapis.com/golang/go${latest}.linux-amd64.tar.gz.sha256"`;
mkdir $golang unless -d $golang;

open my $fh, '<', 'Dockerfile.template' or die $!;
my $doc = do { local $/ = undef; <$fh>; };
close $fh;

$doc =~ s/%%GOLANG_VERSION%%/$latest/;
$doc =~ s/%%GOLANG_DOWNLOAD_SHA256%%/$sha256/;

open $fh, '>', "$golang/Dockerfile" or die $!;
print $fh $doc;
close $fh;

`cp ssh_config $golang`;
`cp dockerd-entrypoint.sh $golang`;
`cp docker-compose.test.yml $golang`;

1;
