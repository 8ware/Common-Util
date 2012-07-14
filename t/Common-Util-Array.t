# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Common-Utils.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use feature 'say';

use Test::More tests => 10;
BEGIN { use_ok('Common::Util::Array', ':all') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

=head1 TEST CASES

=cut

my @array = qw(a b c d e f g h a);

my $idx = index_of(@array, 'a');
is($idx, 0);
is($array[$idx], 'a');

my @idxs = index_of(@array, 'a');
is(@idxs, 2);
is_deeply(\@idxs, [ qw(0 8) ]);
is_deeply([ @array[@idxs] ], [ qw(a a) ]);

my $no_idx = index_of(@array, 'x');
is($no_idx, undef);
my @no_idxs = index_of(@array, 'x');
is(@no_idxs, 0);
is_deeply(\@no_idxs, []);

my $undef_idx = index_of(@array, undef);
is($undef_idx, undef);

