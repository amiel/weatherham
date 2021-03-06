var weatherham_observations;
$(document).ready(function() {

    $('a[rel=facebox]').facebox();

    var flot = null,
        observations = null,
        current_granularity = null,
        placeholder = $('#weather'),
        datasets = null,
        xmin = null, xmax = null,
        yaxis_ranges = null,
        activity_timer = null,
        colors = [
            "#AC2C5A", // wind
            "#14A8CC", // gust
            "#CCBC14", // temp
            "#FE2A40", // wind chill
            "#23CAAF", // baro
            "#8A4F80", // humidity
            "#F2930C", // dew_point
            "#66CC33"  // rain rate
        ],
        primary_color = 'rgba(0, 0, 0, 0)',
        tick_color = 'rgba(255, 255, 255, .05)',
        // panning_distance = 4 * (1000 * 60 * 60), // hours
        // panning_modulo_chunk = panning_distance * 3,
        current_ajax_request = null,
        tooltip_hiding = false, tooltip_showing = false,
        tooltip_date_formats = {
            five_min: 'ddd, mmm d, yyyy"<br/>" h:MM tt Z',
            hourly: 'ddd, mmm d, yyyy"<br/>" htt Z',
            six_hour: 'ddd, mmm d, yyyy tt'
        },
        date_format = 'ddd, mmm d, yyyy h:MMtt Z';


    function show_activity() {
        if ($('#activity').length === 0) $('<div id="activity"></div>').appendTo(placeholder);
        $('#activity').show();
    }

    function hide_activity() {
        $('#activity').hide();
    }

    function show_tooltip(x, y, contents, color) {
        if ($('#tooltip').length === 0)
            $('<div id="tooltip"></div>').appendTo('body');

        if (color) $('#tooltip').css('background-color', color);

        // Align tooltip to the left of the cursor if the cursor is in the right third of the screen
        if (x > ($('html').outerWidth() / 1.5)) {
            var offset = $('#tooltip').outerWidth();
            var placement = { top: y + 5, left: x - 5 - offset };
        } else {
            var placement = { top: y + 5, left: x + 5 };
        }

        $("#tooltip").html(contents).show().css(placement);
    }

    function hide_tooltip() {
        $("#tooltip").hide();
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
        if ($('#left_arrow').length === 0) $('<div id="left_arrow"></div>').appendTo(placeholder);
        $('#left_arrow').show();
    }

    function show_right_arrow() {
        if ($('#right_arrow').length === 0) $('<div id="right_arrow"></div>').appendTo(placeholder);
        $('#right_arrow').show();
    }

    function hide_left_arrow() {
        $('#left_arrow').hide();
    }

    function hide_right_arrow() {
        $('#right_arrow').hide();
    }

    function make_tooltip_for_attribute(tag, attribute, value) {
        return '<' + tag + '><span class="attribute">' + Base.I18n[attribute].title + ':</span> <span class="value">' + value + Base.I18n[attribute].unit + '</span></' + tag + '>';
    }


    var previousPoint = null;
    placeholder.bind("plothover", function (event, pos, item) {
        if (item) {
            hide_right_arrow();
            hide_left_arrow();
            if (previousPoint != item.datapoint) {
                previousPoint = item.datapoint;

                var x = item.datapoint[0],
                y = item.datapoint[1].toFixed(2),
                attribute = item.series.attribute_name,
                mapping = observations.mappings[attribute],

                content = make_tooltip_for_attribute('h3', attribute, y),
                formatted_date = (new Date(x)).format(tooltip_date_formats[current_granularity]);

                if (mapping) content += make_tooltip_for_attribute('h4', mapping, observations.times[x][mapping]);

                content += '<p class="time">' + formatted_date + '</p>';
                show_tooltip(item.pageX, item.pageY, content, item.series.color);
            }
        } else {
            previousPoint = null;
            hide_tooltip();
            if (is_left_edge(pos)) {
                show_left_arrow();
                hide_right_arrow();
            } else if (is_right_edge(pos) && !(xmax === null || xmax == observations.latest_point)) {
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
        for (var name in observations.plot_pairs) {
            if (data.earliest_point < observations.earliest_point) {
                observations.plot_pairs[name] = data.plot_pairs[name].concat(observations.plot_pairs[name]);
            } else if (observations.latest_point < data.latest_point) {
                // forward looking doesn't work yet
            }
        }

        observations.earliest_point = Math.min(observations.earliest_point, data.earliest_point);
        setup_datasets();
    }

    function calculate_panning_distance() {
        return (xmax - xmin) / 4;
    }

    function calculate_panning_modulo_chunk() {
        return calculate_panning_distance() * 3;
    }

    placeholder.bind("plotclick", function (event, pos, item) {
        if (!item) {
            if (current_ajax_request) return;
            var panning_distance = calculate_panning_distance(),
                panning_modulo_chunk = calculate_panning_modulo_chunk();
            if (is_left_edge(pos)) {
                var left_edge = flot.getAxes().xaxis.min,
                    new_left_edge = left_edge - panning_distance;
                xmin = new_left_edge; xmax = flot.getAxes().xaxis.max - panning_distance;

                if (new_left_edge < observations.earliest_point) {
                    var range_begin = +new Date(xmin - (xmin % panning_modulo_chunk)),
                    range_end = +new Date(observations.earliest_point - 1000), // subtract one second from query so that we don't get the same result we already have back
                    url = "/observations/range/" + range_begin + "/" + range_end + "/" + current_granularity + ".json";
                    show_activity();
                    current_ajax_request = $.getJSON(url, function(data) {
                        if (data) merge_datas(data);
                        plot_for_checkboxes();
                        current_ajax_request = null;
                    });
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
        var atm = 29.9213;
        var baro_ticks = function(axis) {
            var res = [[atm, '<span class="baro_label">1 atm</span>']],
                i = Math.ceil(axis.min * 5) / 5;
            do {
                res.push([i, '<span class="baro_label">' + Math.round(i*5)/5 + ' ' + Base.I18n.barometer.unit + '</span>']);
                i += 1/5;
            } while (i < axis.max);
            return res;
        };

        var y_ticks = function(axis) {
            var res = [[32, '<span class="freezing">32</span>']],
                i = axis.min;
            do {
                res.push([i, i]);
                i += 10;
            } while (i < axis.max);
            return res;
        };

        flot = $.plot(placeholder, data, {
            xaxis: { mode: 'time', min: xmin, max: xmax },
            yaxis: { min: 0, max: yaxis_ranges.max, ticks: y_ticks },
            y2axis: {
                min: yaxis_ranges.barometer.min,
                max: yaxis_ranges.barometer.max,
                ticks: baro_ticks
            },
            legend: {
                position: 'nw',
                margin: [ 10, 5 ]
            },
            grid: {
                borderColor: primary_color, borderWidth: 1,
                // backgroundColor: 'rgba(0, 0, 0, 0.4)',
                labelMargin: 10,
                tickColor: tick_color,
                // markings: [ { y2axis: { from: atm, to: atm }, color: tick_color } ], // 1 atmosphere line
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

        $('.metric_toggler').removeClass('-enabled');
        $('.metric_toggler:has(input:checked)').addClass('-enabled');
    }


    $('.metric_toggler input').change(function() {
        plot_for_checkboxes();
    }).each(function(index) {
        $(this).parents('.metric_toggler').css('background-color', colors[index]);
    });
    $('.metric_toggler.default_on input').attr('checked', 'checked');


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


    function do_all_the_shit_needed_to_plot() {
        setup_datasets();
        plot_for_checkboxes();
    }

    function do_the_damn_graph_thing(granularity) {
        show_activity();
        $.getJSON(Base.paths[granularity], function(data) {

            xmax = null; xmin = null;
            current_granularity = granularity;
            observations = data;
            yaxis_ranges = observations.yaxis_ranges;
            weatherham_observations = observations;
            $('#last_observation').html((new Date(observations.latest_point)).format(date_format));
            do_all_the_shit_needed_to_plot();
        });
    }

    $.weatherham = do_the_damn_graph_thing;
    $.weatherham('five_min');
});
