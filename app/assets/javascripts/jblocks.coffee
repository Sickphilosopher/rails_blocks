bem_class = '.js_bem'
RB =
	decls: {}
	cache: {}
	id: 0
	guid: () ->
		return RB.id++
		
window.RB = RB

$.define = (name, proto) ->
	if RB.decls[name]
		throw new Error('Can`t redefine ' + name + ' block')
	RB.decls[name] = proto

###*
# Returns block from cache or create it if doesn't exist
# @return {Block} block
###

$.fn.getBlocks = ->
	@map ->
		$b = $(this)
		bid = $b.data('_bid')
		if bid
			return RB.cache[bid]
		block = new Block($b)
		bid = block._id
		$b.data '_bid', bid
		RB.cache[bid] = block
		block

###*
# Init all blocks inside
###

$.fn.initBlocks = ->
	@find(bem_class).getBlocks()

###*
# Destroy all blocks
###

$.fn.destroyBlocks = ->
	@find(bem_class).getBlocks().each ->
		@destroy()