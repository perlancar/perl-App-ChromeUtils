package App::ChromeUtils;

use 5.010001;
use strict 'subs', 'vars';
use warnings;
use Log::ger;

use App::BrowserUtils ();

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Utilities related to Google Chrome browser',
};

$SPEC{ps_chrome} = {
    v => 1.1,
    summary => "List Chrome processes",
    args => {
        %App::BrowserUtils::args_common,
    },
};
sub ps_chrome {
    App::BrowserUtils::_do_browser('ps', 'chrome', @_);
}

$SPEC{pause_chrome} = {
    v => 1.1,
    summary => "Pause (kill -STOP) Chrome",
    description => $App::BrowserUtils::desc_pause,
    args => {
       %App::BrowserUtils::args_common,
    },
};
sub pause_chrome {
    App::BrowserUtils::_do_browser('pause', 'chrome', @_);
}

$SPEC{unpause_chrome} = {
    v => 1.1,
    summary => "Unpause (resume, continue, kill -CONT) Chrome",
    args => {
        %App::BrowserUtils::args_common,
    },
};
sub unpause_chrome {
    App::BrowserUtils::_do_browser('unpause', 'chrome', @_);
}

$SPEC{pause_and_unpause_chrome} = {
    v => 1.1,
    summary => "Pause and unpause Chrome alternately",
    description => $App::BrowserUtils::desc_pause_and_unpause,
    args => {
        %App::BrowserUtils::args_common,
        %App::BrowserUtils::argopt_periods,
    },
};
sub pause_and_unpause_chrome {
    App::BrowserUtils::_do_browser('pause_and_unpause', 'chrome', @_);
}

$SPEC{chrome_has_processes} = {
    v => 1.1,
    summary => "Check whether Chrome has processes",
    args => {
        %App::BrowserUtils::args_common,
        %App::BrowserUtils::argopt_quiet,
    },
};
sub chrome_has_processes {
    App::BrowserUtils::_do_browser('has_processes', 'chrome', @_);
}

$SPEC{chrome_is_paused} = {
    v => 1.1,
    summary => "Check whether Chrome is paused",
    description => <<'_',

Chrome is defined as paused if *all* of its processes are in 'stop' state.

_
    args => {
        %App::BrowserUtils::args_common,
        %App::BrowserUtils::argopt_quiet,
    },
};
sub chrome_is_paused {
    App::BrowserUtils::_do_browser('is_paused', 'chrome', @_);
}

$SPEC{chrome_is_running} = {
    v => 1.1,
    summary => "Check whether Chrome is running",
    description => <<'_',

Chrome is defined as running if there are some Chrome processes that are *not*
in 'stop' state. In other words, if Chrome has been started but is currently
paused, we do not say that it's running. If you want to check if Chrome process
exists, you can use `ps_chrome`.

_
    args => {
        %App::BrowserUtils::args_common,
        %App::BrowserUtils::argopt_quiet,
    },
};
sub chrome_is_running {
    App::BrowserUtils::_do_browser('is_running', 'chrome', @_);
}

$SPEC{terminate_chrome} = {
    v => 1.1,
    summary => "Terminate  (kill -KILL) Chrome",
    args => {
        %App::BrowserUtils::args_common,
    },
};
sub terminate_chrome {
    App::BrowserUtils::_do_browser('terminate', 'chrome', @_);
}

$SPEC{restart_chrome} = {
    v => 1.1,
    summary => "Restart chrome",
    args => {
        %App::BrowserUtils::argopt_chrome_cmd,
        %App::BrowserUtils::argopt_quiet,
    },
    features => {
        dry_run => 1,
    },
};
sub restart_chrome {
    App::BrowserUtils::restart_browsers(@_, restart_chrome=>1);
}

$SPEC{start_chrome} = {
    v => 1.1,
    summary => "Start chrome if not already started",
    args => {
        %App::BrowserUtils::argopt_chrome_cmd,
        %App::BrowserUtils::argopt_quiet,
    },
    features => {
        dry_run => 1,
    },
};
sub start_chrome {
    App::BrowserUtils::start_browsers(@_, start_chrome=>1);
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

L<App::BraveUtils>

L<App::FirefoxUtils>

L<App::OperaUtils>

L<App::VivaldiUtils>

L<App::BrowserUtils>
