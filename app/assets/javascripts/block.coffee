class window.Block
	constructor: ($b) ->
		@$node = $b
		@name = $$.getBlockName($b)
		@id = $$.guid()
		@params = $b.data('bem')
		#$.extend this, decl.methods
		@_addEvents() if @events
		# if @elements
		# 	for element in @elements
		# 		@_addEvents(element)
		@init() if @init
	
	elem: (e_name, mod_name, mod_value) ->
		klass = ".b-#{@name}__#{e_name}"
		$elem = $(klass, @$node)
		if mod_name
			mod = mod_name
			mod += "_#{mod_value}" if mod_value
			$elem = $elem.filter("#{klass}--#{mod}")
		$elem
		
	_addEvents: (element)->
		for event_name, handler of @events
			p = event_name.split(' ')
			if typeof handler == 'string'
				handler = decl.methods[handler]
			@$node.on p[0], p[1], handler.bind(@)
			
	_trigger: (event) ->
		@$node.trigger event
# class window.Block
# 	constructor: ($b) ->
# 		name = $b.getBlockName()
# 		params = $b.data('bem')
# 		decl = RB.decls[name]
# 		if !decl
# 			throw new Error(name + ' block is not declared')
# 		@name = name
# 		@params = params
# 		@$node = $b
# 		@id = $$.guid()
# 		
# 		$.extend this, decl.methods
# 		@_addEvents()
# 		@_setInited()
# 		@_trigger 'b-inited'
# 		return
# 
# 	_addEvents: ->
# 		decl = $$.decls[@name]
# 		events = decl.events
# 		for e of events
# 			if events.hasOwnProperty(e)
# 				p = e.split(' ')
# 				handler = events[e]
# 				if typeof handler == 'string'
# 					handler = decl.methods[handler]
# 				@$node.on p[0], p[1], handler.bind(@)
# 
# 	_setInited:->
# 		
# 	setMod: (mod, value) ->
# 		
# 	_trigger: (event) ->
# 		@$node.trigger event
# 
# 	destroy: ->
# 		$$.cache[@id] = null
# 		@$node.off()
# 		@_trigger 'b-destroyed'
