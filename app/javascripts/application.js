//= require <facebox>
//= require <base>
//= require <core_ext>

//= require <flot/jquery.flot.min.js>
//= require <flot/jquery.flot.navigate.min.js>
// //= require <flot/jquery.flot.image.min.js>

$(document).ready(function() {
	
	$('a[rel=facebox]').facebox();
	
	var flot = null,
		observations = null,
		placeholder = $('#weather'),
		datasets = null,
		xmin = null, xmax = null,
		colors = ["#edc240", "#afd8f8", "#cb4b4b", "#4da74d", "#9440ed"],
		panning_distance = 4 * (1000 * 60 * 60), // hours
		panning_modulo_chunk = panning_distance * 3,
		current_ajax_request = null;
	
	
	function show_activity() {
		if ($('#activity').length == 0) $('<div id="activity"></div>').appendTo(placeholder);
		$('#activity').fadeTo(100, 0.8);
	}
	
	function hide_activity() {
		$('#activity').fadeTo(100, 0);
	}

	function setup_datasets() {
		var current_color = 0;
		function data_with_label_for(attribute) {
			return { data: observations['plot_pairs'][attribute], color: colors[current_color++], attribute_name: attribute };
		}

		show_activity();		
		datasets = {};
		$('.metric_toggler input').each(function(){ datasets[this.id] = data_with_label_for(this.id); });
		
		datasets.barometer.yaxis = 2;
		return datasets;
	}
	
	
	function show_tooltip(x, y, contents, color) {
		if ($('#tooltip').length == 0)
	        $('<div id="tooltip"></div>').appendTo('body');
		if (color) $('#tooltip').css('background-color', color);
		$('#tooltip').stop().html(contents).css({ top: y + 5, left: x + 5, opacity: 0.80 }).fadeIn(200);
    }
	
	function edge_size() {
		return (flot.getAxes().xaxis.max - flot.getAxes().xaxis.min) / 5;
	}
	
	function is_left_edge(pos) {
		var l = flot.getAxes().xaxis.min,
			r = l + edge_size();
		return l < pos.x && pos.x < r;
	}
	
	function is_right_edge(pos) {
		var r = flot.getAxes().xaxis.max,
			l = r - edge_size();
		return l < pos.x && pos.x < r;
	}
	
	function show_left_arrow() {
		if ($('#left_arrow').length == 0) $('<div id="left_arrow"></div>').css('opacity', '0').appendTo(placeholder);
		$('#left_arrow').stop().fadeTo(50, 0.8);
	}
	
	function show_right_arrow() {
		if ($('#right_arrow').length == 0) $('<div id="right_arrow"></div>').css('opacity', '0').appendTo(placeholder);
		$('#right_arrow').stop().fadeTo(50, 0.8);
	}
	
	function hide_left_arrow() {
		$('#left_arrow').stop().fadeTo(50, 0);
	}
	
	function hide_right_arrow() {
		$('#right_arrow').stop().fadeTo(50, 0);
	}
	
	
	var previousPoint = null;
	placeholder.bind("plothover", function (event, pos, item) {
		if (item) {
			if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;

				$("#tooltip").stop().hide();
				var x = item.datapoint[0],
					y = item.datapoint[1].toFixed(2),
					attribute = item.series.attribute_name;
				

				var content = y + Base.I18n[attribute].unit;
				if (/hi_speed|wind_speed/.test(attribute)) {
					var d = observations['times'][x],
						correct_dir = /hi_speed/.test(attribute) ? 'hi_dir' : 'wind_dir',
						dir = d[correct_dir];
					
					content += ' ' + dir;
				}
				content = '<h3><span class="attribute">' + Base.I18n[attribute].title + ':</span> <span class="value">' + content + '</span></h3><p class="time">' + new Date(x) + '</p>';
				show_tooltip(item.pageX, item.pageY, content, item.series.color);
			}
		} else {
			$("#tooltip").stop().fadeOut(200);
			previousPoint = null;
			
			
			if (is_left_edge(pos)) {
				show_left_arrow();
				hide_right_arrow();
			} else if (is_right_edge(pos)) {
				show_right_arrow();
				hide_left_arrow();
			} else {
				hide_right_arrow();
				hide_left_arrow();
			}
			
		}
	});
	
	function merge_datas(data) {
		$.extend(observations.times, data.times);
		for (name in observations.plot_pairs) {
			if (data.earliest_point < observations.earliest_point) {
				observations.plot_pairs[name] = data.plot_pairs[name].concat(observations.plot_pairs[name]);
			} else if (observations.latest_point < data.latest_point) {
				
			}
		}
		
		observations.earliest_point = Math.min(observations.earliest_point, data.earliest_point);
		setup_datasets();
	}
	
	placeholder.bind("plotclick", function (event, pos, item) {
		if (!item) {
			if (current_ajax_request) { Base.log('double click?', current_ajax_request); return; }
			if (is_left_edge(pos)) {
				var left_edge = flot.getAxes().xaxis.min,
					new_left_edge = left_edge - panning_distance;
				xmin = new_left_edge; xmax = flot.getAxes().xaxis.max - panning_distance;
				if (new_left_edge < observations.earliest_point) {
					var range_begin = +new Date(xmin - (xmin % panning_modulo_chunk)),
						range_end = +new Date(observations.earliest_point - 1000), // subtract one second from query so that we don't get the same result we already have back
						url = "/observations/range/" + range_begin + "/" + range_end + ".json";
					show_activity();
					current_ajax_request = $.getJSON(url, function(data) { merge_datas(data); plot_for_checkboxes(); current_ajax_request = null; });
				} else {
					plot_for_checkboxes();
				}
			} else if (is_right_edge(pos)) {
				var right_edge = flot.getAxes().xaxis.max,
					new_right_edge = right_edge + panning_distance;
				if (new_right_edge > observations.latest_point) {
					// we could check if there is new datas to load, but maybe we should poll or something and load that automatically...4
				} else { // only pan if there is data
					xmin = flot.getAxes().xaxis.min + panning_distance; xmax = new_right_edge;
					plot_for_checkboxes();
				}
			}
		}
	});

	function plot(data, options) {
		var atm = 29.9213,
			baro_ticks = function(axis) {
				var res = [[atm, '1 atm']], i = Math.ceil(axis.min * 5) / 5;
				do {
					res.push([i, Math.round(i*5)/5 + ' ' + Base.I18n.barometer.unit]);
					i += 1/5;
				} while (i < axis.max);
				return res;
			};
		
		flot = $.plot(placeholder, data, {
			xaxis: { mode: 'time', min: xmin, max: xmax },
			yaxis: { min: 0, max: Base.ranges.max },
			y2axis: {
				min: Base.ranges.barometer.min,
				max: Base.ranges.barometer.max,
				ticks: baro_ticks
			},
			legend: {
				position: 'nw',
				margin: [ 10, 5 ]
			},
			grid: {
				markings: [ { y2axis: { from: atm, to: atm } } ], // 1 atmosphere line
				hoverable: true, clickable: true
			},
            series: {
				lines: { show: true }
			}
		});
		hide_activity();
	}
	
	function plot_for_checkboxes() {
		show_activity();
		plot($('.metric_toggler input:checked').map(function(){ return datasets[this.id]; }));
	}
	
	
	$('.metric_toggler input').change(function() {
		plot_for_checkboxes();
	}).each(function(index) {
		$(this).parents('.metric_toggler').css('background-color', colors[index]);
	});
	$('.metric_toggler.default_on input').attr('checked', 'checked');
	
	function do_all_the_shit_needed_to_plot() {
		setup_datasets();
		plot_for_checkboxes();
	}
	
	show_activity();
	$.getJSON(Base.five_min_path, function(data) {
		observations = data;
		do_all_the_shit_needed_to_plot();
	});
});
