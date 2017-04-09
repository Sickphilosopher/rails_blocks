window.$$ =
	decls: {}
	cache: {}
	bem_class: 'js-bem'
	bem_class_selector: ".js-bem"
	bemDataKey: 'bem'

	processOptions: ($dom, b_name, o) ->
		if o.attrs
			for attr, attr_value of o.attrs
				$dom.prop(attr, attr_value)
		if o.content
			$dom.html(o.content)
		if o.mix
			$dom.addClass($$.mixClass(o.mix))
		if o.elements
			for e_name, e_o of o.elements
				$$.makeElement($dom, b_name, e_name, e_o)
			
	makeElement: ($parent, b_name, e_name, o) ->
		tag = o.tag || 'div'
		$e = $("<#{tag} class='#{b_name}__#{e_name}'>")
		$$.processOptions($e, b_name, o)
		if o.prepend
			$parent.prepend $e
		else
			$parent.append $e
		$e
			
	makeBlock: (b_name, o) ->
		o ||= {}
		tag = o.tag || 'div'
		$b = $("<#{tag} class='#{b_name}'>")
		$$.processOptions($b, b_name, o)
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

	elementClass: (b_name, e_name) ->
		"#{b_name}__#{e_name}"