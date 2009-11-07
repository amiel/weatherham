//= require <jquery>
//= require <base>
//= require <flot/jquery.flot.min.js>

$(document).ready(function() {
	Base.observations.reverse();

	function map_date_and_attribute(attribute) {
		return $.map(Base.observations, function(n, i){
			return [[ n.observed_at, n[attribute] ]];
		});
	}

	var wind_speeds = map_date_and_attribute('wind_speed'),
		hi_speeds = map_date_and_attribute('hi_speed'),
		wind_speed_datas = [{ label: "Wind Speed", data: wind_speeds }, { label: "Hi Wind Speeds", data: hi_speeds }];
	$.plot($('#wind_speed'), wind_speed_datas, {xaxis: { mode: 'time' }});
});
