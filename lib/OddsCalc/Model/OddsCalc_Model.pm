package OddsCalc::Model::OddsCalc_Model;
use Moose;
use namespace::autoclean;

use StakesGen;
use TOdds;

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

sub calculate {
	my ($self, $params) = @_;

	my (@oddsArray, @bets, @sorted);
	my ($data, $outcomes, $winCount, $maxCol);
	my @lines = ();
	my $colHeaders = 3;	# stakes, winnings, profit

	SaveState (	$params->{odds},
				$params->{stake},
				$params->{maxLoss} );		
		
	@oddsArray = split (/ /,$params->{odds});
	$outcomes = scalar (@oddsArray);
	
	if ($outcomes < 2) {
		$data = { selections => $outcomes, }; # error, go straight to view
	} else {
		$winCount = 0;

		push (@bets, TOdds->new ($_)) foreach (@oddsArray);
		my $gen = StakesGen->new ($outcomes, $params->{stake} / $params->{incVal} );
	
# anonymous sub for $gen
		
		my $coderef = sub {
			my $obj = shift;
			my (@line) = ();
			my ($stake, $winnings, $profit, $profitStr, $maxProfit, $flag, $i);
					
			$flag = 1;
			
			for ($i = 0;$i < $obj->selections() && $flag;$i++) {
				$stake = (($obj->index($i)) + 1) * $params->{incVal}; # individual stake
				if ((($stake * $bets[$i]->ratio())
					+ $stake - $params->{stake} ) < ( $params->{maxLoss} * -1 ) ) {		# (individual stake * price)  
						$flag = 0;					  										# + stake back - total stake
				}
			}
		
			if ($flag) {
				# Stakes
				for ($i = 0;$i < $obj->selections();$i++) {
					$stake = (($obj->index($i)) + 1) * $params->{incVal};
					push (@line, $stake);
				}
		
				# Winnings
				for ($i = 0;$i < $obj->selections();$i++) {
					$stake = (($obj->index($i)) + 1) * $params->{incVal};
					$winnings = sprintf ("&pound%.2f", ($stake * $bets[$i]->ratio()));
					push (@line, $winnings);
				}

				# Profit
				$maxProfit = 0;
				for ($i = 0;$i < $obj->selections();$i++) {
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

		splice ($_, $maxCol) foreach (@sorted);
		
		$data = {
			array => \@sorted,
			selections => $outcomes,
			stake => sprintf ("&pound%.2f", $params->{stake} ),
			odds => $params->{'odds'},
			colHeaders => $colHeaders,
			winCount => $winCount,
		};
	}
	return $data;
}

sub LoadState {

	open(FH, '<', "OddsCalc.dat") # in c:/mine/perl/oddscalc
		or return {
			odds => 0, stake => 0, maxLoss => 0,
		};

	my ($odds, $stake, $maxLoss) = <FH>;
	close FH;

	my $data = {
		odds => $odds,
		stake => $stake,
		maxLoss => $maxLoss,
	};
	return $data;
}

# save current entries

sub SaveState {
	my ($odds, $stake, $maxLoss) = @_;

	open (FH, '+>', "OddsCalc.dat") # opens new file, deletes old file
		or die "\n Can't open data file !!";

	print FH "$odds \n$stake \n$maxLoss";
	close FH;
}

__PACKAGE__->meta->make_immutable;

1;
