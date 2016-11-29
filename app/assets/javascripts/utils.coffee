window.$$.utils =
	_id: 0
	camelCase: (input) ->
		input.toLowerCase().replace /(^|-)(.)/g, (match, $1, $2) ->
			$2.toUpperCase()
	dash: (input) ->
		input.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()
	guid: () ->
		return @_id++