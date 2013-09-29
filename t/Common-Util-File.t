# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Common-Utils.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More 'no_plan';#tests => 1;
BEGIN { use_ok('Common::Util::File', ':all') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use File::Basename;
use Cwd 'abs_path';

my $t_dir = abs_path dirname($0);

=head1 TEST CASES

=over 4

=item B<chomp>

=item * remove trailing slash of existing directory-path

=item * remove newline of usual string

=item * remove specified char of usual string

=item * remove char from whole array

=cut

my $directory = "/etc/";
my $string = "some test chars \n";
my @strings = ($directory, $string);

chomp $directory;
is($directory, "/etc");

chomp $string;
is($string, "some test chars ");

$/ = ' ';
chomp $string;
is($string, "some test chars");

$_ = 'test ';
chomp;
is($_, 'test');
# TODO investigate $_-scope-behavior

chomp @strings;
is_deeply(\@strings, [$directory, $string]);

=item B<traverse>

=item * test usage: C<traverse {} ''> and C<traverse(sub {}, '')>

=cut

my @files;

traverse { print shift, "\n" } "$t_dir/res";
print '=' x 20, "\n";
@files = traverse { print; print "\n"; 1 } "$t_dir/res";

print scalar @files, "\n";
local $" = "\n";
print "@files\n";


=back

=cut

