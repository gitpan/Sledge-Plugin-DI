use inc::Module::Install;
name 'Sledge-Plugin-DI';
all_from 'lib/Sledge/Plugin/DI.pm';

requires 'Test::More'         => 0;
requires 'version'            => 0;
requires 'UNIVERSAL::require' => 0;
requires 'Test::Base'         => 0;

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More';
test_requires 'YAML';
author_tests('xt');
use_test_base;
auto_include;
WriteAll;
