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

index_of(qw(a b c d), 'b');

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

=head2 copy_of

=cut

#my @array_1 = qw(a b c d);
#my @array_2 = @array_1;
#shift @array_1;
#is_deeply(\@array_1, \@array_2, "array are equal, even after shifting the first");

#@array_2 = copy_of(@array_1);
#is_deeply(\@array_2, \@array_1, "array 2 should be an exact copy of array 1");

#shift @array_2;
#isnt(@array_1, @array_2, "arrays should contain different amount of elements");

=head2 crand

=cut

my(@values, @origin, $length, $count, @randValues);

# testing with a single-value-array
@values = (1);
is(crand @values, 1, "[crand] returns the expected single value");
is(@values, 0, "[crand] array is empty now");
is(crand(@values), undef, "[crand] on passing an empty array, undef is returned");

# prepare
@origin = qw(01 02 06 04 08 07 11 3 15 05 21 18 09 26);
@values = @origin;
$length = @values;

# testing a full run
$count = 0;
while(my $value = crand @values) {
	$count++;
	push @randValues, $value;
}
is($count, $length, "[crand] there were $count of expected $length runs");
is(@values, 0, "[crand] array is empty again, because length is decreased each run by 1");
is_deeply([sort @randValues], [sort @origin],
	"[crand] origin- and random-array should be equals after sorting");


=head2 insert_at

=head3 BORDER CASES

=over 4

=item negative index

=item index greater then last index +1

=back

=cut

