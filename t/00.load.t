use strict;
use warnings;
use Test::More tests => 1;
use t::Config;

sub create_config { t::Config->new({}) }

BEGIN {
use_ok( 'Sledge::Plugin::DI' );
}

diag( "Testing Sledge::Plugin::DI $Sledge::Plugin::DI::VERSION" );
