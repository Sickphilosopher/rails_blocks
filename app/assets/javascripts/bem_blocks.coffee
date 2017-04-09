window.$$ =
	decls: {}
	cache: {}
	bem_class: 'js-bem'
	bem_class_selector: ".js-bem"
	bemDataKey: 'bem'

	processOptions: ($dom, item_name, b_name, o) ->
		if o.attrs
			for attr, attr_value of o.attrs
				$dom.prop(attr, attr_value)
		if o.content
			$dom.html(o.content)
		if o.mix
			$dom.addClass($$.mixClass(o.mix))
		if o.data
			currentData = $dom.data($$.bemDataKey) || {}
			currentData[item_name] = o.data
			$dom.data($$.bemDataKey, currentData)
		if o.elements
			for e_name, e_o of o.elements
				$$.makeElement($dom, b_name, e_name, e_o)
		$dom
	
	makeDom: (o, klass) ->
		o ||= {}
		tag = o.tag || 'div'
		$("<#{tag}>)").addClass(klass)

	makeElement: ($parent, b_name, e_name, o) ->
		item_name = $$.elementClass(b_name, e_name)
		$e = @makeDom(o, item_name)
		$$.processOptions($e, item_name, b_name, o)
		if o.prepend
			$parent.prepend $e
		else
			$parent.append $e
		$e
			
	makeBlock: (b_name, o) ->
		item_name = $$.blockClass(b_name)
		$b = @makeDom(o, item_name)
		$$.processOptions($b, item_name, b_name, o)
		$b
		
	init: ($context) ->
		$blocks = $context.find($$.bem_class_selector)
		$blocks = $blocks.add($context) if $context.hasClass $$.bem_class
		$$.initBlocks($blocks)
		
	initBlocks: ($context, options) ->
		$context.each ->
			$node = $(this)
			allParams = $node.data($$.bemDataKey)
			for own name, params of allParams
				continue if name.indexOf('__') != -1
				$$.getBlock($node, name, params)
	
	getBlock: ($b, name, params)->
		cacheKey = "#{name}_bid"
		bid = $b.data(cacheKey)
		if bid
			return $$.cache[bid]
		try
			block = new $$.decls[$$.utils.camelCase(name)]($b, params, name)
		catch e
			console.error "Can't initialize block #{name}, check declaration. #{e.name} : #{e.message}"

		bid = block.id
		$b.data cacheKey, bid
		$$.cache[bid] = block
		block
			
	makeMod: (name, value) ->
		mod = name
		mod += "_#{value}" if value
		mod
		
	mixClass: (mix) ->
		return "#{mix.b}__#{mix.e}" if mix.e
		mix.b

	blockModClass: (name,  mod, value) ->
		"#{name}--#{$$.makeMod(mod,  value)}"

	elementModClass: (b_name, e_name,  mod, value) ->
		"#{$$.elementClass(b_name,  e_name)}--#{$$.makeMod(mod,  value)}"

	blockClass: (b_name) ->
		b_name

	elementClass: (b_name, e_name) ->
		"#{b_name}__#{e_name}"