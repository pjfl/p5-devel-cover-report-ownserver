package Devel::Cover::Report::OwnServer;

use 5.010001;
use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 3 $ =~ /\d+/gmx );

use Getopt::Long;
use HTTP::Tiny;
use JSON::MaybeXS qw( decode_json encode_json );

my $URI_TEMPLATE = 'http://localhost:5000/coverage/report/%s?version=%s';

# Private subroutines
my $ex = sub {
   my $cmd = shift; return qx( $cmd );
};

my $get_git_info = sub {
   my ($branch) = grep { m{ \A \* }mx } split "\n", $ex->( 'git branch' );

   $branch =~ s{ \A \* \s* }{}mx;

   return { branch => $branch,
            sha    => $ex->( 'git log -1 --pretty=format:"%H"' ), };
};

# Public methods
sub get_options {
   my ($self, $opt) = @_;

   $opt->{option}->{uri_template} = $URI_TEMPLATE;

   GetOptions( $opt->{option}, 'uri_template=s' )
      or die 'Invalid command line options';

   return;
}

sub report {
   my (undef, $db, $config) = @_;

   my %options = map  { $_ => 1 }
                 grep { not m{ path|time }mx } $db->all_criteria, 'force';

   $db->calculate_summary( %options );

   my $info = $get_git_info->();
   # Use the hash since there is a bug: use of uninitialized value $file in
   # hash element at Devel/Cover/DB.pm line 324.
   my $json = encode_json { git_info => $info, summary => $db->{summary} };
   my $http = HTTP::Tiny->new
      ( default_headers => { 'Content-Type' => 'application/json' } );
   my $dist = lc ((($db->runs)[ 0 ])->name);
   my $ver  = (($db->runs)[ 0 ])->version;
   my $url  = sprintf $config->{option}->{uri_template}, $dist, $ver;
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
   template=http://your_coverage_server/coverage/report/%s?version=%s
   cover --uri_template $template -test -report ownServer

=head1 Description

Post test coverage summary to selected service

=head1 Configuration and Environment

The C<uri_template> option should point to your coverage server. Two strings
will be interpolated; the first is the lower-cased distribution name, and the
second one is the version number

=head1 Subroutines/Methods

=head2 C<report>

Send the test coverage summary report to the selected service

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Getopt::Long>

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
