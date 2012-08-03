package Common::Util;

use 5.014002;
use strict;
use warnings;

=head1 NAME

Common::Util - A collection of useful often used functionality

=head1 SYNOPSIS

  use Common::Util qw(index_of File:all Hash);

=head1 DESCRIPTION

This module provides a wrapped access to all its submodules.

=head2 EXPORT

All subroutines specified by the C<EXPORT>-array of each submodule is
imported by default. Tags can have the following structure:

  MODULE-NAME[:EXPORT-TAG]

or

  SUBROUTINE-NAME

The former variant imports all subroutines of the specified export-tag of
the module. If C<:EXPORT-TAG> is omitted the C<:all> export-tag is used.
The latter variant imports the specified subroutine of the package which
is providing that subroutine. In case of the C<:all> import-flag the
subroutines specified by the C<all>-tag of each module is imported.

=head2 PLUGIN CONVENTIONS

A plugin (prefix C<Common::Utils::>) must provide the three exporter-variables
C<@EXPORT>, C<@EXPORT_OK> and C<%EXPORT_TAGS>. All routine-names have to start
with a lower-case letter. By now, only export of subroutines is supported.

=cut

our $VERSION = '0.01';


use Carp;
use Module::Pluggable search_path => 'Common::Util', require => 1;

sub import {
	shift;
	my %export;
	my %subroutines;
	my %tags;
	for my $name (plugins()) {
		next unless $name =~ /Common::Util::(.+)/;
		no strict 'refs';
		$export{$1} = \@{"$name\::EXPORT"};
		for (@{"$name\::EXPORT_OK"}) {
			if(defined $subroutines{$_}) {
				# ambiguous definition of subroutine $_
				carp "Subroutine $_ is already defined in "
						."Common::Util::$subroutines{$_} "
						."(tried to add from Common::Util::$1).";
			} else {
				$subroutines{$_} = $1;
			}
		}
		$tags{$1} = \%{"$name\::EXPORT_TAGS"};
	}
	use Data::Dumper;
	my %imports;
	unless (@_) {
		while (my ($module, $exports) = each %export) {
			$imports{$_} = $module for @{ $exports };
		}
	}
	for (@_) {
		given ($_) {
			when (/^([a-z]\w*)/) {
				if (defined $subroutines{$1}) {
					$imports{$1} = $subroutines{$1};
				} else {
					croak "$1 is not an exported subroutine of any module";
				}
			}
			when (':all') {
				while (my ($module, $tags) = each %tags) {
					next unless defined $tags{$module}->{all};
					$imports{$_} = $module for @{ $tags{$module}->{all} };
				}
			}
			when (':DEFAULT') {
				while (my ($module, $exports) = each %export) {
					$imports{$_} = $module for @{ $exports };
				}
			}
			when (/^([A-Z][a-z]*)(?::([a-z]+))?/) {
				my ($module, $tag) = ($1, $2 || 'all');
				if (defined $tags{$module}->{$tag}) {
					$imports{$_} = $module for @{ $tags{$module}->{$tag} };
				} else {
					croak "'$tag' is not a valid tag of Common::Util::$module";
				}
			}
			default {
				croak "$_ is not a valid export-flag";
			}
		}
	}
	my $caller = caller;
	while (my ($sub, $module) = each %imports) {
		no strict 'refs';
		*{"$caller\::$sub"} = *{"Common::Util::$module\::$sub"};
	}
}


1;
__END__

=head1 TODOs

=over 4

=item * check doubled subroutine identifier and warn for
developing purposes at beginning

=item * ensure that subroutines specified in the export-arrays/-hashes
are really defined (carp and next unless defined &{"$pkg\::$routine"})

=item * support also export of scalars, arrays and hashes

=item * enable selection of routine-package, e.g. Array::index_of

=item * use C<Exporter->export_to_level> for export methods in package
scope

=back

=head1 SEE ALSO

=over 4

=item Common::Util::Array

=item Common::Util::File

=item Common::Util::Hash

=back

=head1 AUTHOR

8ware, E<lt>8wared@googlemail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by 8ware

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
