use strict;
use warnings;

use OddsCalc;

my $app = OddsCalc->apply_default_middlewares(OddsCalc->psgi_app);
$app;

