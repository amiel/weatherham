//= require <jquery>
//= require <base>
//= require <core_ext>

//= require <flot/jquery.flot.min.js>
// //= require <flot/jquery.flot.image.min.js>

var datasets;
$(document).ready(function() {
	Base.observations.reverse();
	var placeholder = $('#weather'),
		datasets = null;
		
	function setup_datasets() {
		if (datasets != null) return datasets;
	
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

		return datasets;
	}
	
	function plot(data) {
		$.plot(placeholder, data, { xaxis: { mode: 'time' } });
	}
	
	function plot_for_checkboxes() {
		plot($('.metric_toggler input:checked').map(function(){ return datasets[this.id]; }));
	}
	
	$('.metric_toggler input').change(function() {
		plot_for_checkboxes();
	}).attr('checked', 'checked');
	
	setup_datasets();
	plot_for_checkboxes();
});
