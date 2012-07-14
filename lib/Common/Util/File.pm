package Common::Util::File;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

=head1 NAME

Common::Util::File - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Common::Util::File;

  perl -MCommon::Util::File -e 'traverse(shift || ".", { print "$_[0]\n" if $_[0] =~ /(?:\..+)?\.sw[a-z]$/ })'

=head1 DESCRIPTION

Stub documentation for Common::Util::File, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

=cut

our %EXPORT_TAGS = ( 'all' => [ qw(
	traverse chomp read_directory
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


use Carp;

use subs qw(traverse chomp read_directory);

=head2 METHODS

=over 4

=item B<traverse>

=cut

sub traverse($\&) { # better use '&' to enable traverse(".", { do_something })
	my $dir_path = shift;
	chomp $dir_path;
	return unless -d $dir_path;
	my $handler = shift;
	read_directory($dir_path, sub {
			my $current_path = "$dir_path/$_";
			if (-f $current_path) {
				$handler->($current_path);
			} else {
				traverse($current_path, $handler);
			}
	});
}

=item B<read_directory>

=cut

sub read_directory($;&) {
	my $path = shift;
	my $handler = shift;
	my @content;
	opendir DIRECTORY, $path or croak "Can't open directory $path: $!";
	for (sort readdir DIRECTORY) {
		next if /^\.{1,2}$/;
		my $fullpath = "$path/$_";
		my $push_flag = 1;
		$push_flag = $handler->($fullpath) if defined $handler;
		push @content, $fullpath if $push_flag;
	}
	closedir DIRECTORY or carp "Can't close directory $path: $!";
	return @content;
}

=item B<chomp> Overrides the builtin C<chomp>, but as opposed to the original,
it will chomp the trailing backslash of strings which represents a valid
directory.

=cut

#NOTE, that this overridden method does NOT behave like the builtin. In fact
#it behaves like the original if a scalar or an array is given, but in case
#of omitted arguments, this method will NOT take the C<$_>-variable. So be
#careful with the import of this method!

sub chomp(;\[$@]) {
	my $string = shift;
	$string = \$_ unless defined $string;
	unless (ref $string) {
		carp "No reference given. Why?";
		$string = \$string;
	} elsif (ref $string eq 'SCALAR') {
		${$string} = $1 if ${$string} =~ /^(.+)$/;
		local $/ = '/' if -d ${$string};
		CORE::chomp(${$string});
	} else {
		for (@{$string}) {
			$_ = $1 if /^(.+)$/;
			local $/ = '/' if -d;
			CORE::chomp;
		}
	}
}

=back

=cut


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

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
