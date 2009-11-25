//= require <facebox>
//= require <base>
//= require <core_ext>

//= require <flot/jquery.flot.min.js>
//= require <flot/jquery.flot.navigate.min.js>
// //= require <flot/jquery.flot.image.min.js>

$(document).ready(function() {
	
	$('a[rel=facebox]').facebox();
	
	var observations = null,
		placeholder = $('#weather'),
		datasets = null,
		xmin = null, xmax = null,
		colors = ["#edc240", "#afd8f8", "#cb4b4b", "#4da74d", "#9440ed"];
	
	
	function show_activity() {
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
	
	
	function show_tooltip(x, y, contents) {
		if ($('#tooltip').length == 0)
	        $('<div id="tooltip"></div>').appendTo('body');
		$('#tooltip').stop().html(contents).css({ top: y + 5, left: x + 5, opacity: 0.80 }).fadeIn(200);
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
				show_tooltip(item.pageX, item.pageY, content);
			}
		} else {
			$("#tooltip").stop().fadeOut(200);
			previousPoint = null;            
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
		
		$.plot(placeholder, data, {
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
		plot($('.metric_toggler input:checked').map(function(){ return datasets[this.id]; }));
	}
	
	
	$('.metric_toggler input').change(function() {
		show_activity();
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
