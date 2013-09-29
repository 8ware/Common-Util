package Common::Util::XML;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Common::Util::File ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	to_hash
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	createChildElement
);

our $VERSION = '0.01';


use Carp;

my $EXTENDING = 1;

=head2 METHODS

=over 4

=item B<to_hash>

Transforms the given XML-document into a hash-array-structure, like:

    element => {
		attribute1 => "value1",
        attribute2 => "value2",
		content => [
			"this is simple text-content",
			{
				attribute3 => "value3"
			}
		]
    }

This method is needful for handling little, manageable XML-documents.

=back

=cut

sub to_hash($) { # XXX to JSON ???
	my $xml = shift;

}


=head2 EXTENSIONS

Following methods are added additionally to classes of the C<XML::LibXML>-module:

=over 4

=cut

if ($EXTENDING) {
	no strict 'refs';

#=item B<XML::LibXML::Element::createChildElement>
#
#This method expects the tag-name of the element to be created. After
#creation the element is added immediately to the element which invokes
#this method. The newly created child is returned.
#
#  $child = $element->createChildElement('tag-name');
#
#=cut

#	*{'XML::LibXML::Element::createChildElement'} = sub {
#		my $self = shift;
#		my $doc = $self->ownerDocument();
#		my $child = $doc->createElement(shift);
#		$self->addChild($child);
#		return $child;
#	};

=item B<XML::LibXML::Node::getElementsByAttribute>

This method delivers all elements which match tag-name, contain the given
attribute match its value by the given regular expression.

  @elements = $node->getElementsByAttribute('tag-name', 'attribute-name', qr/regex/);

=cut

	*{'XML::LibXML::Node::getElementsByAttribute'} = sub {
		my $self = shift;
		my $tag_name = shift;
		my $attribute = shift;
		my $regex = shift;

		my @elements = grep {
			my $value = $_->getAttribute($attribute);
			$value and $value =~ /$regex/;
		} $self->getElementsByTagName($tag_name);

		return wantarray ? @elements : shift @elements;
	};

=item B<XML::LibXML::Node::getElementByAttribute>

This method delivers the first element which tag-name matches the given
one and its attribute as specified has the same value as passed.

  $element = $node->getElementByAttribute('tag-name', 'attribute-name', 'value');

=cut

	*{'XML::LibXML::Node::getElementByAttribute'} = sub {
		my $self = shift;
		my $tag_name = shift;
		my $attribute = shift;
		my $value = shift;

		return scalar $self->getElementsByAttribute(
				$tag_name, $attribute, qr/^$value$/);
	};

=item B<XML::LibXML::Node::getElementByAttribute>

This method delivers the first element which tag-name matches the given
one and its attribute as specified has the same value as passed.

  $element = $node->getElementByAttribute('tag-name', 'attribute-name', 'value');

=cut

	*{'XML::LibXML::Node::getElementByTagName'} = sub {
		my $self = shift;
		my $tag_name = shift;

		my ($element) = $self->getElementsByTagName($tag_name);

		return $element;
	};

=item B<XML::LibXML::Node::getElementByLanguage>

=cut

	*{'XML::LibXML::Node::getElementByXmlLang'} = sub {
		my $self = shift;
		my $tag_name = shift;
		my $lang = shift;
		for ($self->getElementsByTagName($tag_name)) {
			return $_ if $_->getAttribute('xml:lang') eq $lang;
		}
		return undef;
	};

=item B<XML::LibXML::Node::getElementTextByTagName>

=cut

	*{'XML::LibXML::Node::getElementTextByTagName'} = sub {
		my $self = shift;
		my $tag_name = shift;
		my ($element) = $self->getElementsByTagName($tag_name);
		return $element->textContent();
	};

=item B<XML::LibXML::Node::getFirstElementByTagName>

=cut

	*{'XML::LibXML::Node::getFirstElementByTagName'} = sub {
		my $self = shift;
		my $tag_name = shift;
		my ($element) = $self->getElementsByTagName($tag_name);
		return $element->textContent();
	};

=back

=cut

}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Common::Util::File - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Common::Util::File;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Common::Util::File, created by h2xs. It looks like the
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

