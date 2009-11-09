//= require <jquery>
//= require <base>
//= require <core_ext>

//= require <flot/jquery.flot.min.js>
//= require <flot/jquery.flot.navigate.min.js>
// //= require <flot/jquery.flot.image.min.js>

var datasets;
$(document).ready(function() {
	var observations = Base.observations,
		placeholder = $('#weather'),
		datasets = null;
	
	if (typeof observations === 'undefined') return;
	observations.reverse();
		
	function setup_datasets() {
		// if (datasets != null) return datasets;
	
		function map_date_and_attribute(attribute) {
			return $.map(Base.observations, function(n, i){
				return [[ n.observed_at, n[attribute] ]];
			});
		}
	
		var current_color = 0;
		function data_with_label_for(attribute) {
			return { label: Base.I18n[attribute] || attribute.titleize(), data: map_date_and_attribute(attribute), color: current_color++ };
		}
		
		datasets = {};
		$('.metric_toggler input').each(function(){ datasets[this.id] = data_with_label_for(this.id); });
		
		datasets.barometer.yaxis = 2;
		return datasets;
	}
	
	function plot(data) {
		$.plot(placeholder, data, {
			xaxis: { mode: 'time' },
			zoom: { interactive: true },
	        pan: { interactive: true }
		});
	}
	
	function plot_for_checkboxes() {
		plot($('.metric_toggler input:checked').map(function(){ return datasets[this.id]; }));
	}
	
	
	function handle_pan_or_zoom(event, plot) {
		var axes = plot.getAxes(),
			min = axes.xaxis.min,
			max = axes.xaxis.max;
			
		var handle_ajax = function(data) {
			Base.log(data);
		};
		
		var get_range = function(begin, end) {
			$.getJSON('/observations.json', { 'range[begin]': new Date(begin), 'range[end]': new Date(end) }, handle_ajax);
		};
		
		if (min < Base.observations[0].observed_at)
			get_range(min, Base.observations[0].observed_at - 1);
		if (max > Base.observations[Base.observations.length - 1].observed_at)
			get_range(Base.observations[Base.observations.length-1].observed_at, max);
	}
	
	// placeholder.bind('plotpan',  handle_pan_or_zoom);
	// placeholder.bind('plotzoom', handle_pan_or_zoom);

	$('.metric_toggler input').change(function() {
		plot_for_checkboxes();
	}).attr('checked', 'checked');
	
	setup_datasets();
	plot_for_checkboxes();
});
