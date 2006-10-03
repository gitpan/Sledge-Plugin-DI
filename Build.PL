use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Sledge::Plugin::DI',
    license             => 'perl',
    dist_author         => 'Tokuhiro Matsuno <tokuhiro __at__ mobilefactory.jp>',
    dist_version_from   => 'lib/Sledge/Plugin/DI.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Sledge-Plugin-DI-*' ],
);

$builder->create_build_script();
