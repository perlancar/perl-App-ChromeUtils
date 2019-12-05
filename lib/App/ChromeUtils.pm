package App::ChromeUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict 'subs', 'vars';
use warnings;
use Log::ger;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Utilities related to Google Chrome browser',
};

our %argopt_users = (
    users => {
        'x.name.is_plural' => 1,
        'x.name.singular' => 'user',
        summary => 'Kill Chrome processes of certain users only',
        schema => ['array*', of=>'unix::local_uid*'],
    },
);

our %argopt_quiet = (
    quiet => {
        schema => 'true*',
        cmdline_aliases => {q=>{}},
    },
);

our %args_common = (
    %argopt_users,
);

sub _do_chrome {
    require Proc::Find;

    my ($which, %args) = @_;

    my $procs = Proc::Find::find_proc(
        detail => 1,
        filter => sub {
            my $p = shift;

            if ($args{users} && @{ $args{users} }) {
                return 0 unless grep { $p->{uid} == $_ } @{ $args{users} };
            }
            return 0 unless $p->{fname} =~ /\A(chrome)\z/;
            log_trace "Found PID %d (cmdline=%s, fname=%s, uid=%d)", $p->{pid}, $p->{cmndline}, $p->{fname}, $p->{uid};
            1;
        },
    );

    my @pids = map { $_->{pid} } @$procs;

    if ($which eq 'ps') {
        return [200, "OK", $procs, {'table.fields'=>[qw/pid uid euid state/]}];
    } elsif ($which eq 'pause') {
        kill STOP => @pids;
        [200, "OK", "", {"func.pids" => \@pids}];
    } elsif ($which eq 'unpause') {
        kill CONT => @pids;
        [200, "OK", "", {"func.pids" => \@pids}];
    } elsif ($which eq 'terminate') {
        kill KILL => @pids;
        [200, "OK", "", {"func.pids" => \@pids}];
    } elsif ($which eq 'is_paused') {
        my $num_stopped = 0;
        my $num_unstopped = 0;
        my $num_total = 0;
        for my $proc (@$procs) {
            $num_total++;
            if ($proc->{state} eq 'stop') { $num_stopped++ } else { $num_unstopped++ }
        }
        my $is_paused = $num_total == 0 ? undef : $num_stopped == $num_total ? 1 : 0;
        my $msg = $num_total == 0 ? "There are no Chrome processes" :
            $num_stopped   == $num_total ? "Chrome is paused (all processes are in stop state)" :
            $num_unstopped == $num_total ? "Chrome is NOT paused (all processes are not in stop state)" :
            "Chrome is NOT paused (some processes are not in stop state)";
        return [200, "OK", $is_paused, {
            'cmdline.exit_code' => $is_paused ? 0:1,
            'cmdline.result' => $args{quiet} ? '' : $msg,
        }];
    } else {
        die "BUG: unknown command";
    }
}

$SPEC{ps_chrome} = {
    v => 1.1,
    summary => "List Chrome processes",
    args => {
        %args_common,
    },
};
sub ps_chrome {
    _do_chrome('ps', @_);
}

$SPEC{pause_chrome} = {
    v => 1.1,
    summary => "Pause (kill -STOP) Chrome",
    args => {
        %args_common,
    },
};
sub pause_chrome {
    _do_chrome('pause', @_);
}

$SPEC{unpause_chrome} = {
    v => 1.1,
    summary => "Unpause (resume, continue, kill -CONT) Chrome",
    args => {
        %args_common,
    },
};
sub unpause_chrome {
    _do_chrome('unpause', @_);
}

$SPEC{chrome_is_paused} = {
    v => 1.1,
    summary => "Check whether Chrome is paused",
    description => <<'_',

Chrome is defined as paused if *all* of its processes are in 'stop' state.

_
    args => {
        %args_common,
        %argopt_quiet,
    },
};
sub chrome_is_paused {
    _do_chrome('is_paused', @_);
}

$SPEC{terminate_chrome} = {
    v => 1.1,
    summary => "Terminate  (kill -KILL) Chrome",
    args => {
        %args_common,
    },
};
sub terminate_chrome {
    _do_chrome('terminate', @_);
}

1;
# ABSTRACT:

=head1 SYNOPSIS

=head1 DESCRIPTION

This distribution includes several utilities related to Google Chrome browser:

#INSERT_EXECS_LIST


=head1 SEE ALSO

Some other CLI utilities related to Chrome: L<dump-chrome-history> (from
L<App::DumpChromeHistory>).

L<App::FirefoxUtils>

L<App::OperaUtils>

L<App::VivaldiUtils>
