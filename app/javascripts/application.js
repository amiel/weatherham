//= require <jquery>
//= require <base>
//= require <core_ext>

//= require <flot/jquery.flot.min.js>
//= require <flot/jquery.flot.navigate.min.js>
// //= require <flot/jquery.flot.image.min.js>

$(document).ready(function() {
	var observations = null,
		placeholder = $('#weather'),
		datasets = null,
		xmin = null, xmax = null;
	
	
	function show_activity() {
		$('#activity').fadeTo(100, 0.8);
	}
	
	function hide_activity() {
		$('#activity').fadeTo(100, 0);
	}
	
	if (typeof Base.observations === 'undefined') return;
	
	
	function compare_observation(a, b) {
		return ((a.observed_at < b.observed_at) ? -1 : 1);
	}
	
	function sort_observations() {
		show_activity();
		observations = Base.observations;
		observations.sort(compare_observation);
	}
	
	
	function label_for(attribute) {
		return Base.I18n[attribute] ? Base.I18n[attribute].title + ' (' + Base.I18n[attribute].unit + ')' : attribute.titleize();
	}
	
	function setup_datasets() {
		// if (datasets != null) return datasets;
	
		function map_date_and_attribute(attribute) {
			return $.map(Base.observations, function(n, i){
				return [[ n.observed_at, n[attribute] ]];
			});
		}
	
		var current_color = 0;
		function data_with_label_for(attribute) {
			return { label: label_for(attribute), data: map_date_and_attribute(attribute), color: current_color++ };
		}

		show_activity();		
		datasets = {};
		$('.metric_toggler input').each(function(){ datasets[this.id] = data_with_label_for(this.id); });
		
		datasets.barometer.yaxis = 2;
		return datasets;
	}
	
	
	function show_tooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css( {
            position: 'absolute',
            display: 'none',
            top: y + 5,
            left: x + 5,
            border: '1px solid #fdd',
            padding: '2px',
            'background-color': '#fee',
            opacity: 0.80
        }).appendTo("body").fadeIn(200);
    }
    

    var previousPoint = null;
    placeholder.bind("plothover", function (event, pos, item) {
            if (item) {
                if (previousPoint != item.datapoint) {
                    previousPoint = item.datapoint;
                    
                    $("#tooltip").remove();
                    var x = item.datapoint[0],
                        y = item.datapoint[1].toFixed(2);
                    
					var content = y;
					if (/Gust|Wind/.test(item.series.label)) {
						var d = Base.observations.filter(function(t) { return t.observed_at == x; })[0],
							correct_dir = /Gust/.test(item.series.label) ? 'hi_dir' : 'wind_dir',
							dir = d[correct_dir];
						content += ' ' + dir;
					}
					content += ' at ' + new Date(x);
                    show_tooltip(item.pageX, item.pageY, content);
                }
            }
            else {
                $("#tooltip").remove();
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
				markings: [ { y2axis: { from: atm, to: atm } } ],
				hoverable: true, clickable: true
			},
            series: {
				lines: { show: true }
				// points: { show: true }
			},
	        pan: { interactive: true }
		});
		hide_activity();
	}
	
	function plot_for_checkboxes() {
		plot($('.metric_toggler input:checked').map(function(){ return datasets[this.id]; }));
	}
	
	
	function handle_pan_or_zoom(event, plot) {
		var axes = plot.getAxes(),
			min  = axes.xaxis.min,
			max  = axes.xaxis.max;
		
		xmin = min; xmax = max;
			
		var handle_ajax = function(data) {
			Base.observations = Base.observations.concat(data);
			do_all_the_shit_needed_to_plot();
		};
		
		var get_range = function(begin, end, position) {
			$.getJSON(Base.observation_range_path, { 'range[begin]': new Date(begin), 'range[end]': new Date(end) }, handle_ajax);
		};
		
		show_activity();
		if (min < Base.observations[0].observed_at)
			get_range(min, Base.observations[0].observed_at - 1);
		if (max > Base.observations[Base.observations.length - 1].observed_at)
			get_range(Base.observations[Base.observations.length - 1].observed_at + 1, max);
	}
	
	placeholder.bind('plotpan',  handle_pan_or_zoom);

	$('.metric_toggler input').change(function() {
		show_activity();
		plot_for_checkboxes();
	}).attr('checked', 'checked');
	
	function do_all_the_shit_needed_to_plot() {
		sort_observations();
		setup_datasets();
		plot_for_checkboxes();
	}
	do_all_the_shit_needed_to_plot();
});
