use strict;
use warnings;
use Furl::KeepAlive;
use Test::TCP;
use Plack::Loader;
use Test::More;
use Plack::Util;

test_tcp(
    client => sub {
        my $port = shift;
        my $furl = Furl::KeepAlive->new(host => '127.0.0.1', port => $port);
        my ( $code, $headers, $content ) = $furl->request( path => '/' );
        is $code, 200;
        is Plack::Util::header_get($headers, 'Content-Length'), 2;
        is $content, 'OK';
        done_testing;
    },
    server => sub {
        my $port = shift;
        Plack::Loader->auto(port => $port)->run(sub {
            my $env = shift;
            return [ 200, [ 'Content-Length' => 2 ], ['OK'] ];
        });
    }
);
