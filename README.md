# Name

Devel::Cover::Report::OwnServer - Post test coverage summary to selected service

# Synopsis

    perl Build.PL
    ./Build
    template="https://your_coverage_server/coverage/report/%s"
    cover --uri_template ${template} -test -report ownServer

    # OR

    export COVERAGE_URI="https://your_coverage_server/coverage/report/%s"
    perl Build.PL && ./Build && cover -test -report ownServer

# Description

Post test coverage summary to selected service

# Configuration and Environment

Either the `uri_template` option or the `COVERAGE_URI` environment variable
should point to your coverage server. One string will be interpolated; the
lower-cased distribution name. The default template is;

    http://localhost:5000/coverage/report/%s

The value of the environment variable `COVERAGE_TOKEN` is sent to the server
along with the coverage report summary. The token is used to authenticate
post from the integration server to the coverage server. For Travis-CI
use the command

    travis encrypt COVERAGE_TOKEN=<insert your token here>

and place the output in your `.travis.yml` file

    env:
      global:
        - secure: <base64 encoded output from travis encrypt>

This Travis encrypt command must be run from within the working copy of
the repository as it detects the repository name and uses it to salt
the encryption

# Subroutines/Methods

## `get_options`

Adds `uri_template` to the command line options

## `report`

Send the test coverage summary report to the selected service

# See Also

- `http://github.com/pjfl/p5-coverage-server`

    An example implementation of a coverage server that accepts the report
    summaries posted to it by this module and serves `SVG` coverage badges

# Diagnostics

None

# Dependencies

- [Getopt::Long](https://metacpan.org/pod/Getopt::Long)
- [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny)
- [JSON::PP](https://metacpan.org/pod/JSON::PP)

# Incompatibilities

There are no known incompatibilities in this module

# Bugs and Limitations

There are no known bugs in this module. Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Devel-Cover-Report-OwnServer.
Patches are welcome

# Acknowledgements

Larry Wall - For the Perl programming language

# Author

Peter Flanigan, `<pjfl@cpan.org>`

# License and Copyright

Copyright (c) 2016 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic)

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
