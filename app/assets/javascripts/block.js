class Block {
	constructor($b, params, name) {
		this.$node = $b;
		this.name = name;
		this.id = $$.utils.guid();
		this.params = params;
		if (this.events) {
			this._addEvents();
		}
		if (this.init) {
			this.init();
		}
	}

	elem(e_name, mod_name, mod_value, context) {
		var $elem;
		if (context == null) {
			context = this.$node;
		}
		$elem = $(this.elemSelector(e_name, mod_name, mod_value), context);
		$elem.e_name = e_name;
		$elem.b_name = this.name;
		return $elem;
	};

	elemSelector(e_name, mod_name, mod_value) {
		if (mod_name) {
			return "." + ($$.elementModClass(this.name, e_name, mod_name, mod_value));
		}
		return "." + (this._elementClass(e_name));
	};

	on() {
		return this.$node.on.apply(this.$node, arguments);
	};

	_addEvents(element) {
		var event_name, handler, p, ref, results;
		ref = this.events;
		results = [];
		for (event_name in ref) {
			handler = ref[event_name];
			p = event_name.split(' ');
			if (typeof handler === 'string') {
				handler = decl.methods[handler];
			}
			results.push(this.$node.on(p[0], p[1], handler.bind(this)));
		}
		return results;
	};

	_trigger(event, data) {
		return this.$node.trigger(event, data);
	};

	_elementClass(e_name) {
		return $$.elementClass(this.name, e_name);
	};

	addElem(e_name, o, $parent) {
		var $elem;
		o || (o = {});
		$elem = $$.makeElement($parent || this.$node, this.name, e_name, o);
		$elem.e_name = e_name;
		$elem.b_name = this.name;
		return $elem;
	};

	asElem($elem, name) {
		$elem.e_name = name;
		$elem.b_name = this.name;
		return $elem;
	};

	addMod(mod, value) {
		return this.$node.addClass($$.blockModClass(this.name, mod, value));
	};

	delMod(mod, value) {
		return this.$node.removeClass($$.blockModClass(this.name, mod, value));
	};

	toggleMod(mod, value) {
		if (this.hasMod(mod, value)) {
			return this.delMod(mod, value);
		} else {
			return this.addMod(mod, value);
		}
	};

	hasMod(mod, value) {
		return this.$node.hasClass($$.blockModClass(this.name, mod, value));
	};
}