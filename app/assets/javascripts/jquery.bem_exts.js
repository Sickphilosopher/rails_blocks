(function() {
	$(function() {
		var originalEq;
		$.b = function(name) {
			arguments[0] = '.' + name;
			return $.apply(null, arguments);
		};
		originalEq = $.fn.eq;
		return $.fn.extend({
			destroyBlocks: function() {
				return this.find($$.bem_class_selector).getBlocks().each(function() {
					return this.destroy();
				});
			},
			isElem: function() {
				if (this.e_name) {
					return true;
				}
				return false;
			},
			addMod: function(name, value) {
				if (this.isElem()) {
					return this.addClass($$.elementModClass(this.b_name, this.e_name, name, value));
				} else {
					return this.addClass($$.blockModClass(this.b_name, name, value));
				}
			},
			hasMod: function(name, value) {
				if (this.isElem()) {
					return this.hasClass($$.elementModClass(this.b_name, this.e_name, name, value));
				} else {
					return this.hasClass($$.blockModClass(this.b_name, name, value));
				}
			},
			toggleMod: function(mod, value) {
				if (this.hasMod(mod, value)) {
					return this.delMod(mod, value);
				} else {
					return this.addMod(mod, value);
				}
			},
			delMod: function(name, value) {
				if (this.isElem()) {
					return this.removeClass($$.elementModClass(this.b_name, this.e_name, name, value));
				} else {
					return this.removeClass($$.blockModClass(this.b_name, name, value));
				}
			},
			asBlock: function(name, o) {
				this.addClass("" + name);
				return $$.getBlock(this, name, o);
			},
			bemParams: function() {
				var allParams;
				allParams = this.data($$.bemDataKey);
				if (this.isElem()) {
					return allParams[$$.elementClass(this.b_name, this.e_name)];
				} else {
					return console.log('Error, only for elements. Use initBlock for blocks.');
				}
			},
			eq: function() {
				var collection;
				collection = originalEq.apply(this, arguments);
				collection.b_name = this.b_name;
				collection.e_name = this.e_name;
				return collection;
			}
		});
	});

}).call(this);