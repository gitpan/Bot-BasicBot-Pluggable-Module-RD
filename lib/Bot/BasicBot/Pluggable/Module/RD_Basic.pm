package Bot::BasicBot::Pluggable::Module::RD_Basic;
use strict;
use base qw(Bot::BasicBot::Pluggable::Module);
use Bot::BasicBot::Pluggable::Module::RD;

our $VERSION = '0.01';

=head1 NAME

Bot::BasicBot::Pluggable::Module::RD_Basic - Basic RDBot commands

=head1 SYNOPSIS

  !load RD

See the synopsis of L<Bot::BasicBot::Pluggable> for how to load this plugin.

=head1 DESCRIPTION

This is an example module of how to use the 
L<Bot::BasicBot::Pluggable::Module::RD> grammar framework, and should be
used as the basis of creating new pluggable RDBot modules.

=head2 Grammar

The following simple commands are provided:

  say Hello channel
  tell ivorw I'm connected

There's also a catch all verb "Sorry", useful for dealing with, and disposing
of error messages from other bots.

=cut

my $grammar = <<'END';
<autotree>

command:    'say' /.*/
        |   'tell' recipient /.*/
        |   'Sorry'

help:       'say'
        |   'tell'
        |   /\Z/

recipient:  nick
        |   channel

nick:       /\w+/

channel:    /#\w+/

END

=head2 init

This is called by the BasicBot infrastructure. Put anything else here that
needs to happen when your module is loaded.

=cut

sub init {
    my $self = shift;

    Bot::BasicBot::Pluggable::Module::RD->extend( $grammar, __PACKAGE__ );
}

=head2 help namespace

You need to populate subs in __PACKAGE__::Help, one sub for each command
verb you are providing help for. Note that there must be a new method 
available either here or in its super class.

=cut

package Bot::BasicBot::Pluggable::Module::RD_Basic::Help;
use strict;

use base qw(Parse::RecDescent::Topiary::Base);

sub say {
    my $self = shift;

    return "say <text>.   The bot speaketh <text> to all and sundry.";
}

sub tell {
    my $self = shift;

    return "tell <recipient> <text>.   Privmsg or to another channel";
}

=head2 command namespace

You provide subs in __PACKAGE__::Command for each command verb which get
called. Note that there must be a new method available either here or in 
its super class.

=cut

package Bot::BasicBot::Pluggable::Module::RD_Basic::Command;
use strict;

use base qw(Parse::RecDescent::Topiary::Base);

sub say {
    my ( $self, $bot, $context ) = @_;

    my $msg = $self->{__PATTERN1__};
    $bot->say( %$context, address => '', body => $msg );
}

sub tell {
    my ( $self, $bot, $context ) = @_;

    my $msg   = $self->{__PATTERN1__};
    my $recip = $self->{recipient};

    if ( exists $recip->{nick} ) {
        my $nick = $recip->{nick}{__VALUE__};
        $bot->say(
            %$context,
            body    => $msg,
            channel => 'msg',
            who     => $nick
        );
    }
    else {
        my $chan = $recip->{channel}{__VALUE__};
        $bot->say(
            %$context,
            body    => $msg,
            address => '',
            channel => $chan
        );
    }
}

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org>.

=head1 AUTHOR

    Ivor Williams
    CPAN ID: IVORW
     
    ivorw@cpan.org
     

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

1;

