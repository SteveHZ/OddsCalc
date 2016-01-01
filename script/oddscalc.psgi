#!/usr/bin/env perl
use strict;
use warnings;
use OddsCalc;
#use MySpeedDial;

my $app = OddsCalc->psgi_app(@_);
#my $app2 = MySpeedDial->psgi_app(@_);
 
#OddsCalc->setup_engine('PSGI');
#my $app = sub { OddsCalc->run(@_) };

