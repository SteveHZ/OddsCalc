
// 	OddsCalc.js 05-11/08/14

$(document).ready (function () {
	$('#infoForm').submit (function (event) {
		ajaxFunc ();
		event.preventDefault ();
	});
});

function ajaxFunc () {
	var odds =  $('#odds').val();
	var stake = $('#stake').val();
	var maxLoss = $('#maxLoss').val();
	var incVal = $('#incVal').val();

	var queryString = "?odds="+ odds + "&stake=" + stake + "&maxLoss=" + maxLoss + "&incVal=" + incVal;
	$('#results').html ("<h4>Calculating...</h4>");

	var request = $.ajax ({
		url: 'results' + queryString,
		type : "GET",
		datatype : "html"
	});
	
	request.done (function (msg) {
		$('#results').html (msg);
		stripeTables ();
	});
	
	request.fail (function (jqXHR, textStatus) {
		alert ("Request failed : " + textStatus);
	});
}
