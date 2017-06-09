class window.Block
	constructor: ($b, params, name) ->
		@$node = $b
		@name = name
		@id = $$.utils.guid()
		@params = params
		#$.extend this, decl.methods
		@_addEvents() if @events
		# if @elements
		# 	for element in @elements
		# 		@_addEvents(element)
		@init() if @init
	
	elem: (e_name, mod_name, mod_value, context = @$node) ->
		$elem = $(@elemSelector.apply(@, arguments), context)
		$elem.e_name = e_name
		$elem.b_name = @name
		$elem
	
	elemSelector: (e_name, mod_name, mod_value) ->
		return ".#{$$.elementModClass(@name, e_name,  mod_name,  mod_value)}" if mod_name
		".#{@_elementClass(e_name)}"
	
	on: () ->
		@$node.on.apply(@$node, arguments)

	_addEvents: (element)->
		for event_name, handler of @events
			p = event_name.split(' ')
			if typeof handler == 'string'
				handler = decl.methods[handler]
			@$node.on p[0], p[1], handler.bind(@)
			
	_trigger: (event, data) ->
		@$node.trigger event, data

	_elementClass: (e_name) ->
		$$.elementClass(@name, e_name)

	addElem: (e_name, o, $parent) ->
		o ||= {}
		$elem = $$.makeElement($parent || @$node, @name, e_name, o)
		$elem.e_name = e_name
		$elem.b_name = @name
		$elem

	asElem: ($elem, name) ->
		$elem.e_name = name
		$elem.b_name = @name
		$elem
		
	addMod: (mod, value) ->
		@$node.addClass($$.blockModClass(@name, mod, value))
		
	delMod: (mod, value) ->
		@$node.removeClass($$.blockModClass(@name, mod, value))
	
	toggleMod: (mod, value) ->
		if @hasMod(mod, value)
			@delMod(mod, value)
		else
			@addMod(mod, value)

	hasMod: (mod, value) ->
		@$node.hasClass($$.blockModClass(@name, mod, value))