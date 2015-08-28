$ ->
	$.b = (name) ->
		arguments[0] = '.b-' + name
		$.apply(null, arguments)