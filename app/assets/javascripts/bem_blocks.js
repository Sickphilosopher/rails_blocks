(function() {
	var hasProp = {}.hasOwnProperty;

	window.$$ = {
		decls: {},
		cache: {},
		bem_class: 'js-bem',
		bem_class_selector: ".js-bem",
		bemDataKey: 'bem',
		blockInitializationErrorHandler: function(e) {
			return console.error("Can't initialize block " + name + ", check declaration. " + e.name + " : " + e.message);
		},
		processOptions: function($dom, item_name, b_name, o) {
			var attr, attr_value, currentData, e_name, e_o, ref, ref1;
			if (o.attrs) {
				ref = o.attrs;
				for (attr in ref) {
					attr_value = ref[attr];
					$dom.prop(attr, attr_value);
				}
			}
			if (o.content) {
				$dom.html(o.content);
			}
			if (o.mix) {
				$dom.addClass($$.mixClass(o.mix));
			}
			if (o.data) {
				currentData = $dom.data($$.bemDataKey) || {};
				currentData[item_name] = o.data;
				$dom.data($$.bemDataKey, currentData);
			}
			if (o.elements) {
				ref1 = o.elements;
				for (e_name in ref1) {
					e_o = ref1[e_name];
					$$.makeElement($dom, b_name, e_name, e_o);
				}
			}
			return $dom;
		},
		makeDom: function(o, klass) {
			var tag;
			o || (o = {});
			tag = o.tag || 'div';
			return $("<" + tag + ">)").addClass(klass);
		},
		makeElement: function($parent, b_name, e_name, o) {
			var $e, item_name;
			item_name = $$.elementClass(b_name, e_name);
			$e = this.makeDom(o, item_name);
			$$.processOptions($e, item_name, b_name, o);
			if (o.prepend) {
				$parent.prepend($e);
			} else {
				$parent.append($e);
			}
			return $e;
		},
		makeBlock: function(b_name, o) {
			var $b, item_name;
			item_name = $$.blockClass(b_name);
			$b = this.makeDom(o, item_name);
			$$.processOptions($b, item_name, b_name, o);
			return $b;
		},
		init: function($context) {
			var $blocks;
			$blocks = $context.find($$.bem_class_selector);
			if ($context.hasClass($$.bem_class)) {
				$blocks = $blocks.add($context);
			}
			return $$.initBlocks($blocks);
		},
		initBlocks: function($context, options) {
			return $context.each(function() {
				var $node, allParams, name, params, results;
				$node = $(this);
				allParams = $node.data($$.bemDataKey);
				results = [];
				for (name in allParams) {
					if (!hasProp.call(allParams, name)) continue;
					params = allParams[name];
					if (name.indexOf('__') !== -1) {
						continue;
					}
					results.push($$.getBlock($node, name, params));
				}
				return results;
			});
		},
		getBlock: function($b, name, params) {
			var bid, block, cacheKey, e;
			cacheKey = name + "_bid";
			bid = $b.data(cacheKey);
			if (bid) {
				return $$.cache[bid];
			}
			try {
				block = new $$.decls[$$.utils.camelCase(name)]($b, params, name);
				bid = block.id;
				$b.data(cacheKey, bid);
				$$.cache[bid] = block;
				return block;
			} catch (error) {
				e = error;
				if ($$.blockInitializationErrorHandler) {
					return $$.blockInitializationErrorHandler(e, name, params);
				}
			}
		},
		makeMod: function(name, value) {
			var mod;
			mod = name;
			if (value) {
				mod += "_" + value;
			}
			return mod;
		},
		mixClass: function(mix) {
			if (mix.e) {
				return mix.b + "__" + mix.e;
			}
			return mix.b;
		},
		blockModClass: function(name, mod, value) {
			return name + "--" + ($$.makeMod(mod, value));
		},
		elementModClass: function(b_name, e_name, mod, value) {
			return ($$.elementClass(b_name, e_name)) + "--" + ($$.makeMod(mod, value));
		},
		blockClass: function(b_name) {
			return b_name;
		},
		elementClass: function(b_name, e_name) {
			return b_name + "__" + e_name;
		}
	};

}).call(this);