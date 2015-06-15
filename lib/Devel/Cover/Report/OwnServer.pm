package Devel::Cover::Report::OwnServer;

use 5.010001;
use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 2 $ =~ /\d+/gmx );

use HTTP::Tiny;
use JSON::MaybeXS qw( decode_json encode_json );

my $API_ENDPOINT = 'http://localhost:5000/coverage/report/%s?version=%s';

sub report {
   my ($pkg, $db, $options) = @_;

   my %options = map  { $_ => 1 }
                 grep { not m{ path|time }mx } $db->all_criteria, 'force';

   $db->calculate_summary( %options );

   # Use the hash since there is a bug: use of uninitialized value $file in
   # hash element at Devel/Cover/DB.pm line 324.
   my $json = encode_json { summary => $db->{summary} };
   my $http = HTTP::Tiny->new
      ( default_headers => { 'Content-Type' => 'application/json' } );
   my $dist = lc ((($db->runs)[ 0 ])->name);
   my $ver  = (($db->runs)[ 0 ])->version;
   my $url  = sprintf $API_ENDPOINT, $dist, $ver;
   my $resp = $http->post( $url, { content => $json } );

   if ($resp->{success}) {
      my $content = decode_json $resp->{content};

      print $content->{message}."\n";
   }
   else { warn 'Status '.$resp->{status}.' '.$resp->{reason}."\n" }

   return;
}

1;

__END__

=pod

=encoding utf-8

=head1 Name

Devel::Cover::Report::OwnServer - Post test coverage summary to selected service

=head1 Synopsis

   perl Build.PL
   ./Build
   cover -test -report ownServer

=head1 Description

Post test coverage summary to selected service

=head1 Configuration and Environment

Defines no attributes

=head1 Subroutines/Methods

=head2 C<report>

Send the test coverage summary report to the selected service

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<HTTP::Tiny>

=item L<JSON::MaybeXS>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module. Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Devel-Cover-Report-OwnServer.
Patches are welcome

=head1 Acknowledgements

Larry Wall - For the Perl programming language

=head1 Author

Peter Flanigan, C<< <pjfl@cpan.org> >>

=head1 License and Copyright

Copyright (c) 2015 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

=cut

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
