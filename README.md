# Name

Devel::Cover::Report::OwnServer - Post test coverage summary to selected service

# Synopsis

    perl Build.PL
    ./Build
    template=http://your_coverage_server/coverage/report/%s
    cover --uri_template $template -test -report ownServer

# Description

Post test coverage summary to selected service

# Configuration and Environment

The `uri_template` option should point to your coverage server. One string
will be interpolated; the lower-cased distribution name. The default
template is;

    http://localhost:5000/coverage/report/%s

# Subroutines/Methods

## `get_options`

Adds `uri_template` to the command line options

## `report`

Send the test coverage summary report to the selected service

# Diagnostics

None

# Dependencies

- [Getopt::Long](https://metacpan.org/pod/Getopt::Long)
- [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny)
- [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS)

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

Copyright (c) 2015 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic)

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
