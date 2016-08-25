#! C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use OddsCalc;

my $app = OddsCalc->psgi_app(@_);
