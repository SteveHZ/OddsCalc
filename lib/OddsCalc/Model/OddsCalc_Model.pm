package OddsCalc::Model::OddsCalc_Model;
use Moose;
use namespace::autoclean;

use StakesGen;
use MyOdds;

extends 'Catalyst::Model';

=head1 NAME

OddsCalc::Model::OddsCalc_Model - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.


=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my $datafile = 'C://Mine/perl/OddsCalc/root/static/data/OddsCalc.dat';

sub calculate {
	my ($self, $params) = @_;

	my (@oddsArray, @bets, @sorted);
	my @lines = ();
	my ($outcomes, $winCount, $odds_str, $maxCol);
	my $colHeaders = 3;	# stakes, winnings, profit

	for (keys (%$params)) {
		$params->{$_} = 0 if (! $params->{$_});
	}

	SaveState (	$params->{odds},
				$params->{stake},
				$params->{maxLoss} );		
		
	@oddsArray = split (/ /, $params->{odds});
	$outcomes = scalar (@oddsArray);
	
	if ($outcomes < 2) {
		return {
			selections => $outcomes,
		}; # error, go straight to view

	} else {
		$winCount = 0;

		push (@bets, MyOdds->new ($_)) for (@oddsArray);
		$odds_str = join (', ', map { $_->show () } @bets);
		
		my $gen = StakesGen->new ($outcomes, $params->{stake} / $params->{incVal} );
	
# anonymous sub for $gen
		
		my $coderef = sub {
			my $obj = shift;
			my (@line) = ();
			my ($stake, $winnings, $profit, $profitStr, $maxProfit, $i);
			my $flag = 1;
			
			for ($i = 0; $i < $obj->selections () && $flag; $i++) {
				$stake = (($obj->index($i)) + 1) * $params->{incVal}; # individual stake
				if ((($stake * $bets[$i]->ratio())											# (individual stake * price)  
					+ $stake - $params->{stake} ) < ( $params->{maxLoss} * -1 ) ) {			# + stake back - total stake
						$flag = 0;					  										# < maximum allowed loss
				}
			}
		
			if ($flag) {
				# Stakes
				for ($i = 0; $i < $obj->selections (); $i++) {
					$stake = (($obj->index($i)) + 1) * $params->{incVal};
					push (@line, $stake);
				}
		
				# Winnings
				for ($i = 0; $i < $obj->selections (); $i++) {
					$stake = (($obj->index($i)) + 1) * $params->{incVal};
					$winnings = sprintf ("&pound%.2f", ($stake * $bets[$i]->ratio()));
					push (@line, $winnings);
				}

				# Profit
				$maxProfit = 0;
				for ($i = 0; $i < $obj->selections (); $i++) {
					$stake = (($obj->index($i)) + 1) * $params->{incVal};
					$profit = ($stake * $bets[$i]->ratio()) + $stake - $params->{stake};
					$profitStr = sprintf ("&pound%.2f", $profit);
					push (@line, $profitStr);
					$maxProfit = $profit if $profit > $maxProfit;	# sort by this later
				}
				$winCount++;
				push (@line, $maxProfit);
				push (@lines, \@line);
			}
		};

# end of anonymous sub
		
		$gen->onIteration ($coderef);
		$gen->run();

# sort lines array by the maxProfit element of each sub-array, last item in each row
# then remove maxProfit element from each sub-array before sending to the view

		$maxCol = $outcomes * $colHeaders;
		@sorted = sort { @$b[$maxCol] <=>
						 @$a[$maxCol] } @lines;

		splice (@$_, $maxCol) for (@sorted);
		
		return {
			array => \@sorted,
			selections => $outcomes,
			stake => sprintf ("&pound%.2f", $params->{stake} ),
			odds => $odds_str,
			colHeaders => $colHeaders,
			winCount => $winCount,
		};
	}
}

sub LoadState {
	open(FH, '<', $datafile) # in c:/mine/perl/oddscalc
		or return {
			odds => 0, stake => 0, maxLoss => 0,
		};

	my ($odds, $stake, $maxLoss) = <FH>;
	close FH;

	return {
		odds => $odds,
		stake => $stake,
		maxLoss => $maxLoss,
	};
}

# save current entries

sub SaveState {
	my ($odds, $stake, $maxLoss) = @_;

	open (FH, '+>', $datafile) # opens new file, deletes old file
		or die "\n Can't open data file !!";

	print FH "$odds \n$stake \n$maxLoss";
	close FH;
}

__PACKAGE__->meta->make_immutable;

1;
