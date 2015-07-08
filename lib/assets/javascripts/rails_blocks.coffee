#=require 'block'

$ ->
	$.extend $,
		RB: 
			blocks: {}
		decl: (name, options) ->
			block = @createBlockDeclaration(name, options)
			if(options['init'] != undefined)
				options['init'].call(block)
		createBlockDeclaration: (name, options) ->
			return new Block name, options