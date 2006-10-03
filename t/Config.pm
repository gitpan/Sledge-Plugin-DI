package t::Config;
use strict;
use warnings;

sub new {
    my ($class, $config) = @_;
    bless $config, $class;
}

sub DESTROY { } # nop for AUTOLOAD
our $AUTOLOAD;
sub AUTOLOAD {
    my ($self,) = @_;
    $AUTOLOAD =~ s/.*:://;
    $self->{$AUTOLOAD};
}

1;
