# Name

Devel::Cover::Report::OwnServer - Post test coverage summary to selected service

# Synopsis

    perl Build.PL
    ./Build
    cover -test -report ownServer

# Description

Post test coverage summary to selected service

# Configuration and Environment

Defines no attributes

# Subroutines/Methods

## `report`

Send the test coverage summary report to the selected service

# Diagnostics

None

# Dependencies

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
