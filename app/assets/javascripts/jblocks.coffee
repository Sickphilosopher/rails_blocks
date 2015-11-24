camelCase = (input) ->
	input.toLowerCase().replace /(^|-)(.)/g, (match, $1, $2) ->
		$2.toUpperCase()

window.$$ =
	decls: {}
	cache: {}
	utils: {}
	_id: 0
	bem_class: 'js_bem'
	bem_class_selector: '.js_bem'
	guid: () ->
		return @_id++

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
		$e = $("<#{tag} class='b-#{b_name}__#{e_name}'>")
		$$.processOptions($e, b_name, o)
		if o.prepend
			$parent.prepend $e
		else
			$parent.append $e
		$e
			
	makeBlock: (b_name, o) ->
		tag = o.tag || 'div'
		$b = $("<#{tag} class='b-#{b_name}'>")
		$$.processOptions($b, b_name, o)
		$b
		
	init: ($context) ->
		$$.getBlocks($context.find($$.bem_class_selector))
		$$.getBlocks($context) if $context.hasClass $$.bem_class
		
	getBlocks: ($context) ->
		$context.map ->
			$b = $(this)
			bid = $b.data('_bid')
			if bid
				return $$.cache[bid]
			block = new $$.decls[camelCase($$.getBlockName($b))]($b)
			bid = block.id
			$b.data '_bid', bid
			$$.cache[bid] = block
			block
			
	getBlockName: ($b) ->
		regexp = /^b(-[a-zA-Z0-9]+)+$/
		for klass in $b.attr('class').split(/\s+/)
			return klass.replace('b-', '') if regexp.test(klass)
			
	makeMod: (name, value) ->
		mod = name
		mod += "_#{value}" if value
		mod
		
	mixClass: (mix) ->
		"b-#{mix.b}__#{mix.e}"
			
$.fn.destroyBlocks = ->
	@find($$.bem_class_selector).getBlocks().each ->
		@destroy()

$.fn.addMod = (name, value) ->
	mod = $$.makeMod(name, value)
	if @e_name
		@addClass("b-#{@b_name}__#{@e_name}--#{mod}")
	else
		@addClass("b-#{@b_name}--#{mod}")

$.fn.delMod = (name, value) ->
	mod = $$.makeMod(name, value)
	if @e_name
		@removeClass("b-#{@b_name}__#{@e_name}--#{mod}")
	else
		@removeClass("b-#{@b_name}--#{mod}")