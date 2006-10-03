use t::TestDI;
use t::Config;
require Sledge::Plugin::DI;

plan tests => 1 * blocks;

run {
    my $block = shift;

    my $pages = $block->input->{pages};
    {
        no strict 'refs';
        *{"$pages\::create_config"} = sub { t::Config->new($block->input) };
    }
    eval qq{
        package $pages;
        Sledge::Plugin::DI->import;
    };
    die $@ if $@;

    my %expected = %{ $block->expected };
    while (my ($meth, $class) = each %expected) {
        no strict 'refs';
        isa_ok *{"$pages\::$meth"}->($pages), $class;
    }
};

__END__

=== Simple Scalar
--- input yaml
pages: t::TestPages
di:
  manager: t::Module::A
--- expected yaml
create_manager: t::Module::A

=== Simple Array
--- input yaml
pages: t::TestPages::Array
di:
  manager:
    - pages: t::TestPages
      manager: t::Module::A
    - pages: t::TestPages::Array
      manager: t::Module::B
--- expected yaml
create_manager: t::Module::B

=== Simple Array
--- input yaml
pages: t::TestPages2
di:
  manager:
    - pages: t::TestPages2
      manager: t::Module::A
    - pages: t::TestPages2::Array
      manager: t::Module::B
--- expected yaml
create_manager: t::Module::A
