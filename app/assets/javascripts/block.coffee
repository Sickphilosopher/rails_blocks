class window.Block
	constructor: ($b) ->
		@$node = $b
		@name = $b.getBlockName()
		@id = $$.guid()
		@params = $b.data('bem')
		#$.extend this, decl.methods
		@_addEvents() if @events
	
	get_element: (e_name) ->
		$(".b-#{@name}__#{e_name}", @$node)
		
	_addEvents: ->
		for event_name, handler of @events
			p = event_name.split(' ')
			if typeof handler == 'string'
				handler = decl.methods[handler]
			@$node.on p[0], p[1], handler.bind(@)
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
