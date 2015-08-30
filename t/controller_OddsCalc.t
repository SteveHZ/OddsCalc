use strict;
use warnings;
use Test::More;


use Catalyst::Test 'OddsCalc';
use OddsCalc::Controller::OddsCalc;

ok( request('/oddscalc')->is_success, 'Request should succeed' );
done_testing();
