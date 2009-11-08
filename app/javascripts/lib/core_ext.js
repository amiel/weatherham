
String.prototype.capitalize = function() {
	return this[0].toUpperCase() + this.substr(1, this.length-1);
};

String.prototype.titleize = function() {
	res = new Array();
	var parts = this.split(/_| /);
	$.each(parts, function(index, part) {
		res.push(part.capitalize());
	});
	return res.join(" ");
};
