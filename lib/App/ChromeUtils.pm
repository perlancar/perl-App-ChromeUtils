package App::ChromeUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict 'subs', 'vars';
use warnings;
use Log::ger;

use App::BrowserUtils ();

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

L<App::BrowserUtils>
