# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Common-Util-XML.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use feature 'say';

use Test::More 'no_plan';#tests => 1;
BEGIN { use_ok('Common::Util::XML', ':all') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use XML::LibXML;

my $doc = XML::LibXML::Document->new('1.0', 'UTF-8');
my $elem = $doc->createElement('test');

#
# TODO
# check functionality of
#
#   $node = $parent->addNewChild( $nsURI, $name );
#

is($elem->toString(), '<test/>');
my $child = $elem->addNewChild('', 'child');
is_deeply($child->parentNode(), $elem);
is($elem->toString(), '<test><child/></test>');

$child->setAttribute('number', 1);
is_deeply($elem->getElementByAttribute('child', 'number', 1), $child);
is_deeply($elem->getElementByAttribute('child', 'number', 2), undef);

