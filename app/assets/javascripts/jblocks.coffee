camelCase = (input) ->
	input.toLowerCase().replace /(^|-)(.)/g, (match, $1, $2) ->
		$2.toUpperCase()

window.$$ =
	decls: {}
	cache: {}
	_id: 0
	bem_class: '.js_bem'
	guid: () ->
		return @_id++
	processOptions: ($dom, b_name, o) ->
		if o.attrs
			for attr, attr_value of o.attrs
				$dom.prop(attr, attr_value)
		if o.content
			$dom.html(o.content)
		if o.elements
			$$.makeElements($dom, b_name, o.elements)
			
	makeElements: ($parent, b_name, elements) ->
		for e_name, o of elements
			tag = o.tag || 'div'
			$e = $("<#{tag} class='b-#{b_name}__#{e_name}'>")
			$$.processOptions($e, b_name, o)
			$parent.append $e
			
	makeBlock: (b_name, o) ->
		tag = o.tag || 'div'
		$b = $("<#{tag} class='b-#{b_name}'>")
		$$.processOptions($b, b_name, o)
		$b#.initBlocks()
		
	init: ($context) ->
		$$.getBlocks($context.find($$.bem_class))
		
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
			
$.fn.destroyBlocks = ->
	@find($$.bem_class).getBlocks().each ->
		@destroy()
		