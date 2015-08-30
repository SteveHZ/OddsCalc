package OddsCalc::View::ajax;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

OddsCalc::View::ajax - TT View for OddsCalc

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
