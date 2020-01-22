#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab:ft=perl
# 
# Print i3 workspaces on every change.
# 
# Format: 
#   For every workspace (x = workspace name)
#       - "FOCx" -> Focused workspace
#       - "INAx" -> Inactive workspace
#       - "ACTx" -> Ative workspace
#       - "URGx" -> Urgent workspace
#
# NOPE: prints lemonbar codes
#
# Uses AnyEvent I3 0.8 -> https://metacpan.org/module/AnyEvent::I3
# Based in i3-wsbar of Michael Stapelberg -> http://code.stapelberg.de/git/i3/tree/contrib/i3-wsbar
#
# 16 feb 2015 - Electro7

use AnyEvent::I3;
use AnyEvent;
use common::sense;
# this badly written program needs SIGPIPE handling
undef $SIG{PIPE};
my %c = (
     fg => '#ccadcc'
    ,urgent   => '#e122a4'
    ,focused  => '#9b0877'
    ,inactive => '#4c114e'
    ,visible  => '#637e35'
);

# non-portable dirname(1) implementation
$0 = "lemonstatus: workspace";
my $socket_path = undef;
my ($workspaces, $outputs) = ([], {});
my $w = AnyEvent->timer(
    after => 3,
    cb => sub {
        die "Connection to i3 timed out. Verify socket path ($socket_path)";
        exit 1;
    }
);

my $i3 = i3($socket_path);

# Disable buffering
$| = 1;
#STDERR->autoflush;
#STDOUT->autoflush;

# Wait a short amount of time and try to connect to i3 again
sub reconnect { 
    exit 1;
#    print "reconecting\n";
#    my $timer;
#    $i3 = i3($socket_path);
#    if (!defined($w)) {
#        $w = AnyEvent->timer(
#            after => 3,
#            cb => sub {
#                die "Connection to i3 timed out. Verify socket path ($socket_path)";
#                exit 1;
#            }
#        );
#    }
#
#    my $c = sub {
#        $timer = AnyEvent->timer(
#            after => 0.01,
#            cb => sub { $i3->connect->cb(\&connected) }
#        );
#    };
#    $c->();
}

# Connection attempt succeeded or failed
sub connected {
    my ($cv) = @_;

    if (!$cv->recv) {
        reconnect();
        return;
    }

    $w = undef;

    $i3->subscribe({
        workspace => \&ws_change,
        output => \&output_change,
        _error => sub { reconnect() }
    });
    ws_change();
    output_change();
}

# Called when a ws changes
sub ws_change {
    # Request the current workspaces and update the output afterwards
    $i3->get_workspaces->cb(
        sub {
            my ($cv) = @_;
            $workspaces = $cv->recv;
            update_output();
        });
}

# Called when the reply to the GET_OUTPUTS message arrives
sub got_outputs {
    my $reply = shift->recv;
    my %new = map { ($_->{name}, $_) } grep { $_->{active} } @{$reply};

    for my $name (keys %new) {
        $outputs->{$name} = $new{$name};
    }

    update_output();
}

sub output_change {
    $i3->get_outputs->cb(\&got_outputs)
}

sub update_output {
    my $out;

    for my $name (keys %{$outputs}) {
#        $out .= "WSP ";

        for my $ws (@{$workspaces}) {
            $out .= '%{B';
            if ($ws->{focused}) {
                # orange
                $out .= $c{focused}
            } elsif ($ws->{urgent}) {
                # red
                $out .= $c{urgent}
            } elsif ($ws->{visible}) {
                # other monitor
                $out .= $c{visible}
            } else {
                # inactive: yellow
                $out .= $c{inactive}
            }
            $out .= " F$c{fg}}%{A:".($ws->{name} =~ s/:/\\:/gr).":} ".
                    ($ws->{name} =~ s/^[0-9]+://r) . " %{A}";
        }

        $out .= "\n";

        print $out;
    }
}

$i3->connect->cb(\&connected);

# let AnyEvent do the rest ("endless loop")
AnyEvent->condvar->recv

