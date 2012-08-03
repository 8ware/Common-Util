package Common::Util::Array;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Common::Util::Array ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	index_of
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

#our @EXPORT = qw(
#	
#);

our $VERSION = '0.01';


use Carp;

sub index_of(\@$) {
	my @array = @{ (shift) };
	my $value = shift;
	return undef unless defined $value;
	my @indexes = grep { $array[$_] eq $value } 0 .. $#array;
	return wantarray ? @indexes : $indexes[0];
}

# border-cases
# - negative index
# - index greater then last index +1
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

sub copy_of(\@) {
	return @{ $_[0] };
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Common::Util::Array - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Common::Util::Array;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Common::Util::Array, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

8ware, E<lt>andydefrank@(none)E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by 8ware

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

