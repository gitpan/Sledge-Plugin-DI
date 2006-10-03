package Sledge::Plugin::DI;
use warnings;
use strict;
use version; our $VERSION = qv('0.0.1');
use Carp;
use UNIVERSAL::require;

sub import {
    my $pkg = caller(0);
    my $plugin = shift;

    my $config = $pkg->create_config->di;
    for my $meth (keys %$config) {
        no strict 'refs'; ## no critic

        *{"$pkg\::create_$meth"} = sub {
            my $self = shift;

            if (ref $config->{$meth} eq 'ARRAY') {
                # array
                my $class;
                my $proto = ref $self || $self;
                for my $elem (@{$config->{$meth}}) {
                    if ($proto =~ /$elem->{pages}/) {
                        $class = $elem->{$meth};
                    }
                }

                if ($class) {
                    $plugin->_require_with_package($pkg, $class);
                    return $class->new($self, @_);
                } else {
                    Carp::croak("can't determine $meth class");
                }
            } else {
                # scalar
                $plugin->_require_with_package($pkg, $config->{$meth});
                return $config->{$meth}->new($self, @_);
            }
        };
    }
}

sub _require_with_package {
    my ($class, $package, $load) = @_;

    # FIXME: (do you know more smart way?)
    eval qq/
        {
            package $package;
            use $load;
        }
    /; ## no critic

    die $@ if $@;
}

1; # Magic true value required at end of module

__END__

=head1 NAME

Sledge::Plugin::DI - dependency injection for Sledge

=head1 SYNOPSIS

    use Sledge::Plugin::DI;

    package Your::Pages;
    use Sledge::Plugin::DI;
    # no create_* methods!

    # in your config.yaml
    common:
      di:
        session: Sledge::Session::Memcached
        cache:   Sledge::Cache::Memcached
        charset: Sledge::Charset::Default
        authorizer:
          - pages:      Your::Pages
            authorizer: Null
          - pages:      Your::Pages::Admin
            authorizer: Your::Authorizer::Admin
          - pages:      Your::Pages::My
            authorizer: Your::Authorizer::My
        manager:
          - pages:      Your::Pages
            session:    Cookie
          - pages:      Your::Pages::Mobile
            session:    StickyQuery

=head1 DESCRIPTION

You can easily to injection the dependency.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
