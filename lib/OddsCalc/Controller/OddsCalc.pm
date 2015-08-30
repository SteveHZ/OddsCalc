package OddsCalc::Controller::OddsCalc;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

OddsCalc::Controller::OddsCalc - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.
Odds Calc
v1.0 28/06/15

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path {
    my ( $self, $c ) = @_;

	$c->response->redirect ($c->uri_for ($self->action_for ('home')));
}

sub home :Local {
	my ($self, $c) = @_;

	$c->stash ( template => 'home.tt2',
				data => $c->model ('OddsCalc_Model')
						  ->LoadState (),
	);
}

sub results :Local {
	my ($self, $c) = @_;
	my $params = $c->request->params;

	$c->stash (	template => 'results.tt2',
				no_wrapper => 1,
				data => $c->model ('OddsCalc_Model')
						  ->calculate ($params),
	);
}

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
