(function() {
	window.$$.utils = {
		_id: 0,
		camelCase: function(input) {
			return input.toLowerCase().replace(/(^|-)(.)/g, function(match, $1, $2) {
				return $2.toUpperCase();
			});
		},
		dash: function(input) {
			return input.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
		},
		guid: function() {
			return this._id++;
		}
	};

}).call(this);