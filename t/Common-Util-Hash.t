# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Common-Utils.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use feature 'say';

use Test::More tests => 2;
BEGIN { use_ok('Common::Util::Hash', ':all') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

=head1 TEST CASES

=cut

my %hash = ( a => 'b', c => 'd' );
my $key = key_of(%hash, 'b');
is($key, 'a', "key of 'b' is 'a'");

