package Common::Util::Array;

use 5.014002;
use strict;
use warnings;

=head1 NAME

Common::Util::Array - A collection of useful subroutines operating on
or with arrays

=head1 SYNOPSIS

  use Common::Util::Array ':all';

  @array = qw(a b c d e f);

  $index = index_of(@array, 'd');     # $index is 3

  $value = crand(@array);             # $value is one of a ... f
                                      # @array lost $value as element

=head1 DESCRIPTION

This module provide common array-related utilities. For more detailed
information about the provided subroutines see the section B<METHODS>.

=head2 EXPORT

Exports nothing by default. All subroutines mentioned above can be
imported individually or via the C<:all>-tag.

=cut

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	index_of crand
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

#our @EXPORT = qw();

our $VERSION = '0.01';

#=head2 DEPENDENCIES
#
#=cut

use Carp;

=head2 METHODS

=over 4

=item B<index_of>

Returns the first index of the specified element within the given array
in scalar context. In list context all found indices are returned.

=cut

sub index_of(\@$) {
	my @array = @{ (shift) };
	my $value = shift;
#	my $value = pop;
#	my @array = @_;
	return undef unless defined $value;
	my @indexes = grep { $array[$_] eq $value } 0 .. $#array;
	return wantarray ? @indexes : $indexes[0];
}

#=item B<insert_at>
#
#=cut

sub insert_at(\@$$) {
	my ($arrayref, $item, $index) = @_;
	if ($index < 1) {
		carp "Given index is negative." if $index < 0;
		unshift $arrayref, $item;
	} elsif ($index > $#{ $arrayref }) {
		carp "Given index is out of bounds." if $index > @{ $arrayref };
		push $arrayref, $item;
	} else {
		# insert_at qw(a c), 'b', 1
		@{ $arrayref } = (@{ $arrayref }[0 .. $index -1], $item,
				@{ $arrayref }[$index .. $#{ $arrayref }]);
	}
}

#=item B<copy_of>
#
#=cut

sub copy_of(\@) {
	return @{ $_[0] };
}

=item B<crand>

The C<crand>-function accepts an array returns a random-chosen value
which is removed from the array. If the array is empty C<undef> is will
be returned. The common usage is as follows:

  while ($value = crand(@array)) {
      # do stuff with the random value
      # e.g. push it to a random-array
  }

=cut

srand;

sub crand(\@) {
	my $arrayref = shift;
	return undef unless @{ $arrayref };
	my $idx = int rand @{ $arrayref };
	return splice @{ $arrayref }, $idx, 1;
}

=back

=cut


1;
__END__

#=head1 SEE ALSO

=head1 AUTHOR

8ware, E<lt>8wared@googlemail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by 8ware

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

