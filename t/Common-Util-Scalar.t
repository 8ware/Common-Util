# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl String-Utils.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More 'no_plan';
BEGIN { use_ok('Common::Util::Scalar', ':all') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $minimum = min_length qw(aaa bb cccc);
is($minimum, 2, "[min_length] minimum should be 2");

my $string = "abc";
my $char = char_at($string, 0);
is(length $char, 1, "[char_at] length should be 1");
is($char, 'a', "[char_at] first char should be 'a' (positive index)");
$char = char_at($string, -1);
is($char, 'c', "[char_at] last char should be 'c' (negative index)");

is(char_at('a', 1), undef, "[char_at] undef should be returned if index is the end of string");
is(char_at('a', 2), undef, "[char_at] undef should be returned if index out of range");

