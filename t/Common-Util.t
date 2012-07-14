=head1 NAME

Test-suite for the C<Common::Util>-module.

=cut

use strict;
use warnings;

use Test::More tests => 9;

=head TEST CASES

=over 4

=item subroutine-name as import-flag results in importing the subroutine

=item C<MODULE-NAME>:C<EXPORT-TAG> as import-flag results in importing
all subroutines of the given export-tag of the specified module

=item the module-name as import-flag results in importing all subroutines
of the C<all> export-flag of the specified module

=back

=cut

use subs qw(get_subroutines get_difference);

SKIP: {
	my @origin_state = get_subroutines();
	require_ok('Common::Util::Array');
	skip("Common::Util::Array has no 'index_of' in \@EXPORT_OK", 2)
			unless 'index_of' ~~ @Common::Util::Array::EXPORT_OK;
	use_ok('Common::Util', 'index_of');
	my @difference = get_difference(@origin_state);
	is_deeply(\@difference, [ 'index_of' ],
		"subroutine 'index_of' (Array)  should be imported");
}

SKIP: {
	my @origin_state = get_subroutines();
	require_ok('Common::Util::File');
	skip("Common::Util::File has no 'all' export-tag", 2)
			unless defined $Common::Util::File::EXPORT_TAGS{all};
	use_ok('Common::Util', 'File:all');
	my @difference = get_difference(@origin_state);
	push my @export_tags_all,
			sort @{ $Common::Util::File::EXPORT_TAGS{all} };
	is_deeply(\@difference, \@export_tags_all,
		"subroutines of the 'all' export-tag (File) should be imported");
}

SKIP: {
	my @origin_state = get_subroutines();
	require_ok('Common::Util::Hash');
	skip("Common::Util::Hash has no 'all' export-tag", 2)
			unless defined $Common::Util::Hash::EXPORT_TAGS{all};
	use_ok('Common::Util', 'Hash');
	my @difference = get_difference(@origin_state);
	push my @export_tags_all,
			sort @{ $Common::Util::Hash::EXPORT_TAGS{all} };
	is_deeply(\@difference, \@export_tags_all,
		"subroutines of the 'all' export-tag (Hash) should be imported");
}


#
# returns all subroutines defined in the package's symbol-table
#
sub get_subroutines(;$) {
	my $package = shift || __PACKAGE__;
	no strict 'refs';
	return grep { defined &{"$package\::$_"} } keys %{"$package\::"};
}

#
# returns the difference betwween the given state of imported subroutines
# and the current one
#
sub get_difference(@) {
	my @current_state = get_subroutines();
	return sort grep { not $_ ~~ @_ } @current_state;
}

