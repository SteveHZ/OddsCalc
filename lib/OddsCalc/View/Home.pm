package OddsCalc::View::Home;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
	INCLUDE_PATH => [
		OddsCalc->path_to ('root','src'),
		OddsCalc->path_to ('root','static','js'),
	],
	WRAPPER => 'wrapper.tt2',
	render_die => 1,
);

=head1 NAME

OddsCalc::View::Home - TT View for OddsCalc

=head1 DESCRIPTION

TT View for OddsCalc.

=head1 SEE ALSO

L<OddsCalc>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
