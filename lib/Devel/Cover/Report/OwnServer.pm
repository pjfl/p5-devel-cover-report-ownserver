package Devel::Cover::Report::OwnServer;

use 5.010001;
use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 2 $ =~ /\d+/gmx );

use Getopt::Long;
use HTTP::Tiny;
use JSON::MaybeXS qw( decode_json encode_json );

my $URI_TEMPLATE = 'http://localhost:5000/coverage/report/%s';

# Private subroutines
my $ex = sub {
   my $cmd = shift; return qx( $cmd );
};

my $get_git_info = sub {
   my ($dist, $version) = @_;

   my ($branch) =  grep { m{ \A \* }mx } split "\n", $ex->( 'git branch' );
       $branch  =~ s{ \A \* \s* }{}mx;
   my $remotes  =  [ map    { my ($name, $url) = split q( ), $_;
                              +{ name => $name, url => $url } }
                     split m{ \n }mx, $ex->( 'git remote -v' ) ];

   return { author_name     => $ex->( 'git log -1 --pretty=format:"%aN"' ),
            author_email    => $ex->( 'git log -1 --pretty=format:"%ae"' ),
            branch          => $branch,
            commit          => $ex->( 'git log -1 --pretty=format:"%H"' ),
            committer_name  => $ex->( 'git log -1 --pretty=format:"%cN"' ),
            committer_email => $ex->( 'git log -1 --pretty=format:"%ce"' ),
            dist            => $dist,
            message         => $ex->( 'git log -1 --pretty=format:"%s"' ),
            remotes         => $remotes,
            version         => $version, };
};

# Public methods
sub get_options {
   my ($self, $opt) = @_; $opt->{option}->{uri_template} = $URI_TEMPLATE;

   GetOptions( $opt->{option}, 'uri_template=s' )
      or die 'Invalid command line options';

   return;
}

sub report {
   my (undef, $db, $config) = @_;

   my %options = map  { $_ => 1 }
                 grep { not m{ path|time }mx } $db->all_criteria, 'force';

   $db->calculate_summary( %options );

   my $dist    = (($db->runs)[ 0 ])->name;
   my $version = (($db->runs)[ 0 ])->version;
   # Use the hash since there is a bug: use of uninitialized value $file in
   # hash element at Devel/Cover/DB.pm line 324.
   my $report  = { info    => $get_git_info->( $dist, $version ),
                   summary => $db->{summary} };
   my $http    = HTTP::Tiny->new
      ( default_headers => { 'Content-Type' => 'application/json' } );
   my $uri     = sprintf $config->{option}->{uri_template}, lc $dist;
   my $resp    = $http->post( $uri, { content => encode_json $report } );

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
   template=http://your_coverage_server/coverage/report/%s
   cover --uri_template $template -test -report ownServer

=head1 Description

Post test coverage summary to selected service

=head1 Configuration and Environment

The C<uri_template> option should point to your coverage server. One string
will be interpolated; the lower-cased distribution name. The default
template is;

   http://localhost:5000/coverage/report/%s

=head1 Subroutines/Methods

=head2 C<get_options>

Adds C<uri_template> to the command line options

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
