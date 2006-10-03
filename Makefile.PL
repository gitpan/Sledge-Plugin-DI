use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Sledge::Plugin::DI',
    AUTHOR              => 'Tokuhiro Matsuno <tokuhiro __at__ mobilefactory.jp>',
    VERSION_FROM        => 'lib/Sledge/Plugin/DI.pm',
    ABSTRACT_FROM       => 'lib/Sledge/Plugin/DI.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'         => 0,
        'version'            => 0,
        'UNIVERSAL::require' => 0,
        'Test::Base'         => 0,
      },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Sledge-Plugin-DI-*' },
);
