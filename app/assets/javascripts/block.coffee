class window.Block
	initialize: (block) ->
		name = block.data('b')
		params = block.data('p')
		decl = RB.decls[name]
		if !decl
			throw new Error(name + ' block is not declared')
		info =
			name: name
			params: params
			$node: block
			_id: window.guid()
		$.extend this, info, decl.methods
		@_addEvents()
		@_setInited()
		@_trigger 'b-inited'
		return

	_addEvents: ->
		decl = RB.decls[@name]
		events = decl.events
		for e of events
			if events.hasOwnProperty(e)
				p = e.split(' ')
				handler = events[e]
				if typeof handler == 'string'
					handler = decl.methods[handler]
				@$node.on p[0], p[1], handler.bind(this)

	_setInited:->
		@$node.addClass 'jb-inited'

	_trigger: (name) ->
		@$node.trigger name

	destroy: ->
		RB.cache[@_id] = null
		@$node.removeClass 'jb-inited'
		@$node.off()
		@_trigger 'b-destroyed'
