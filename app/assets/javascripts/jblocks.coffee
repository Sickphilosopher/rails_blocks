class window.$$
	@decls: {}
	@cache: {}
	@_id: 0
	constructor: ()->
		console.log('init')
	@guid: () ->
		return @_id++
	@register: (b_name, klass) ->
		@decls[b_name] = klass
		
	@makeElements: ($parent, b_name, elements) ->
		for e_name, element of elements
			tag = element.tag || 'div'
			$e = $("<#{tag} class='b-#{b_name}__#{e_name}'>")
			console.log e_name, element.attrs
			if element.attrs
				for attr, attr_value of element.attrs
					$e.prop(attr, attr_value)
			if element.content
				$e.html(element.content)
			if element.elements
				$e.append(@makeElements($e, b_name, element.elements))
			$parent.append $e
			
	@makeBlock: (b_name, o) ->
		$b = $("<div class='b-#{b_name}'>")
		@makeElements($b, b_name, o.elements) if o.elements
		$b#.initBlocks()
		
new $$

bem_class = '.js_bem'
	
$.define = (name, proto) ->
	if $$.decls[name]
		throw new Error('Can`t redefine ' + name + ' block')
	$$.decls[name] = proto

###*
# Returns block from cache or create it if doesn't exist
# @return {Block} block
###

$.fn.getBlocks = ->
	@map ->
		$b = $(this)
		bid = $b.data('_bid')
		if bid
			return $$.cache[bid]
		block = new $$.decls[$b.getBlockName()]($b)
		bid = block.id
		$b.data '_bid', bid
		$$.cache[bid] = block
		block

$.fn.initBlocks = ->
	@find(bem_class).getBlocks()

$.fn.destroyBlocks = ->
	@find(bem_class).getBlocks().each ->
		@destroy()
		
$.fn.getBlockName = ->
	regexp = /^b(-[a-zA-Z0-9]+)+$/
	for klass in @attr('class').split(/\s+/)
		return klass.replace('b-', '') if regexp.test(klass)