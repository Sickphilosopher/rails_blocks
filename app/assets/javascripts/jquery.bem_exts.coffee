$ ->
	$.b = (name) ->
		arguments[0] = '.' + name
		$.apply(null, arguments)
	
	originalEq = $.fn.eq;

	$.fn.extend
		destroyBlocks: ->
			@find($$.bem_class_selector).getBlocks().each ->
				@destroy()

		isElem: ->
			return true if @e_name
			false

		addMod: (name, value) ->
			if @isElem()
				@addClass($$.elementModClass(@b_name, @e_name, name, value))
			else
				@addClass($$.blockModClass(@b_name, name, value))
		
		hasMod: (name, value) ->
			if @isElem()
				return @hasClass($$.elementModClass(@b_name, @e_name, name, value))
			else
				return @hasClass($$.blockModClass(@b_name, name, value))

		toggleMod: (mod, value) ->
			if @hasMod(mod, value)
				@delMod(mod, value)
			else
				@addMod(mod, value)

		delMod: (name, value) ->
			if @isElem()
				@removeClass($$.elementModClass(@b_name, @e_name, name, value))
			else
				@removeClass($$.blockModClass(@b_name, name, value))
				
		asBlock: (name, o) ->
			@addClass("#{name}")
			$$.getBlock(@, name, o)

		bemParams: () ->
			allParams = @data($$.bemDataKey)
			if @isElem()
				return allParams[$$.elementClass(@b_name, @e_name)]
			else
				console.log('Error, only for elements. Use initBlock for blocks.')

		eq: () ->
			collection = originalEq.apply(@, arguments)
			collection.b_name = @b_name
			collection.e_name = @e_name
			collection