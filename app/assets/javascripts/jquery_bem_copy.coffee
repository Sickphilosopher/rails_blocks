### @required jQuery ###

(($) ->

	###*
	# Base BEM class.
	# @constructor
	###

	BEM = (config) ->

		###*
		# Default configuration.
		# @type {Object}
		###

		@config = config or {}
		@blockClassRe = @buildBlockClassRe()
		@elemClassRe = @buildElemClassRe()
		@modClassRe = @buildModClassRe()
		return

	###*
	# Get parent block of element.
	# @public
	#
	# @param {Object} $this
	# @return {Object}
	###

	BEM::getBlock = ($this) ->
		blockClass = @getBlockClass($this)
		block = $this.closest('.' + blockClass)
		block.selector = blockClass
		block

	###*
	# Switch block context.
	# @public
	#
	# @param {Object} $this
	# @param {String} block
	# @param {String} [elem]
	# @return {Object}
	###

	BEM::switchBlock = ($this, block, elem) ->
		`var elem`
		elem = elem or null
		if elem then ($this.selector = @buildSelector(
			block: block
			elem: elem)) else ($this.selector = @buildSelector(block: block))
		$this

	###*
	# Find element in block.
	# @public
	#
	# @param	{Object}	$this		DOM element
	# @param	{String}	elemKey	Element name
	# @return {Object}
	###

	BEM::findElem = ($this, elemKey) ->
		blockClass = @getBlockClass($this)
		elemName = @buildElemClass(blockClass, elemKey)
		elem = $this.find('.' + elemName)
		elem

	###*
	# Get value of modifier.
	# @public
	#
	# @param {Object} $this
	# @param {String} modKey
	# @return {String}
	###

	BEM::getMod = ($this, modKey) ->
		mods = @extractMods($this.first())
		if mods[modKey] != undefined
			return mods[modKey]
		null

	###*
	# Check modifier of element.
	# @public
	#
	# @param {Object} $this
	# @param {String} modKey
	# @param {String} [modVal]
	# @return {Boolean}
	###

	BEM::hasMod = ($this, modKey, modVal) ->
		mods = @extractMods($this.first())
		if modVal
			if mods[modKey] == modVal
				return true
		else
			if mods[modKey]
				return true
		false

	###*
	# Set modifier on element.
	# @public
	#
	# @param {Object} $this
	# @param {String} modKey
	# @param {String} [modVal]
	# @param {Object}
	###

	BEM::setMod = ($this, modKey, modVal) ->
		self = this
		selector = $this.selector
		$this.each ->
			current = $(this)
			current.selector = selector
			mods = self.extractMods(current)
			baseName = self.getBaseClass(current)
			if mods[modKey] != undefined
				oldModName = self.buildModClass(baseName, modKey, mods[modKey])
				current.removeClass oldModName
			if modVal != false
				newModName = self.buildModClass(baseName, modKey, modVal)
			current.addClass(newModName).trigger 'setmod', [
				modKey
				modVal
			]
			return
		$this

	###*
	# Delete modifier on element.
	# @public
	#
	# @param {Object} $this
	# @param {String} modKey
	# @param {String} [modVal]
	# @param {Object}
	###

	BEM::delMod = ($this, modKey, modVal) ->
		self = this
		selector = $this.selector
		$this.each ->
			`var modName`
			current = $(this)
			current.selector = selector
			mods = self.extractMods(current)
			baseName = self.getBaseClass(current)
			if modVal
				if mods[modKey] == modVal
					modName = self.buildModClass(baseName, modKey, mods[modKey])
			else
				modName = self.buildModClass(baseName, modKey, mods[modKey])
			current.removeClass(modName).trigger 'delmod', [
				modKey
				modVal
			]
			return
		$this

	###*
	# Filtering elements by modifier.
	# @public
	#
	# @param {Object} $this
	# @param {String} modKey
	# @param {String} [modVal]
	# @param {Boolean} [inverse]
	# @return {Object}
	###

	BEM::byMod = ($this, modKey, modVal, inverse) ->
		`var inverse`
		`var modVal`
		self = this
		modVal = modVal or null
		inverse = inverse or false
		selector = $this.selector
		result = $()
		$this.each ->
			`var modName`
			current = $(this)
			current.selector = selector
			mods = self.extractMods(current)
			baseName = self.getBaseClass(current)
			if modVal
				if mods[modKey] == modVal
					modName = self.buildModClass(baseName, modKey, mods[modKey])
			else
				if mods[modKey] != undefined
					modName = self.buildModClass(baseName, modKey, mods[modKey])
			result = result.add(if inverse then current.not('.' + modName) else current.filter('.' + modName))
			return
		result.selector = selector
		result

	###*
	# Get block names from element.
	# @protected
	#
	# @param {Object|String} $this
	# @return {Object}
	###

	BEM::extractBlocks = ($this) ->
		self = this
		result = []
		selectors = @getClasses($this)
		$.each selectors, (i, sel) ->
			type = self.getClassType(sel)
			if type == 'block'
				result.push sel
			else if type == 'elem'
				elem = sel.split(self.config.elemPrefix)
				result.push elem[0]
			return
		result

	###*
	# Get element names from element.
	# @protected
	#
	# @param {Object} $this
	# @return {Object}
	###

	BEM::extractElems = ($this) ->
		self = this
		result = []
		$.each self.getClasses($this), (i, className) ->
			if self.getClassType(className) == 'elem'
				elemName = className.split(self.config.elemPrefix)
				result.push elemName[1]
			return
		result

	###*
	# Get modifiers from element.
	# @protected
	#
	# @param {Object} $this
	# @return {Object}
	###

	BEM::extractMods = ($this) ->
		self = this
		result = {}
		$this.each ->
			`var $this`
			$this = $(this)
			$.each self.getClasses($this), (i, className) ->
				`var modVal`
				if self.getClassType(className) == 'mod'
					re = self.buildModClassRe().exec(className)
					modName = re[1].split(self.config.modDlmtr)
					if modName[1] != undefined and modName[1] != false
						modVal = modName[1]
					else
						modVal = true
					result[modName[0]] = modVal
				return
			return
		result

	###*
	# Get classes names from element.
	# @protected
	#
	# @param {Object} $this
	# @return {Object}
	###

	BEM::getClasses = ($this) ->
		classes = undefined
		result = []
		if typeof $this == 'object'
			if $this.selector.indexOf('.') == 0
				classes = $this.selector.split('.')
			else if $this.attr('class') != undefined
				classes = $this.attr('class').split(' ')
			else
				return null
		else
			classes = $this.split('.')
		$.each classes, (i, className) ->
			if className != ''
				result.push $.trim(className)
			return
		result

	###*
	# Build regexp for blocks.
	# @protected
	#
	# @return {RegExp}
	###

	BEM::buildBlockClassRe = ->
		new RegExp('^(' + @config.namePattern + ')$')

	###*
	# Build regexp for elements.
	# @protected
	#
	# @return {RegExp}
	###

	BEM::buildElemClassRe = ->
		new RegExp('^' + @config.namePattern + @config.elemPrefix + '(' + @config.namePattern + ')$')

	###*
	# Build regexp for modifiers.
	# @protected
	#
	# @return {RegExp}
	###

	BEM::buildModClassRe = ->
		new RegExp('^(?:' + @config.namePattern + '|' + @config.namePattern + @config.elemPrefix + @config.namePattern + ')' + @config.modPrefix + '(' + @config.namePattern + '((' + @config.modDlmtr + @config.namePattern + ')$|$))')

	###*
	# Build class name for block.
	# @protected
	#
	# @param {String} blockName
	# @return {String}
	###

	BEM::buildBlockClass = (blockName) ->
		blockName

	###*
	# Build class name for element.
	# @protected
	#
	# @param {String} blockName
	# @param {String} elemKey
	# @return {String}
	###

	BEM::buildElemClass = (blockName, elemKey) ->
		blockName + @config.elemPrefix + elemKey

	###*
	# Build class name for modifier.
	# @protected
	#
	# @param {String} blockName
	# @param {String} modKey
	# @param {String} modVal
	# @return {String}
	###

	BEM::buildModClass = (baseClass, modKey, modVal) ->
		if modVal != undefined and modVal != true
			baseClass + @config.modPrefix + modKey + @config.modDlmtr + modVal
		else
			baseClass + @config.modPrefix + modKey

	###*
	# Build selector from object or string.
	# @private
	#
	# @param {String|Object}
	# @param {String}
	# @return {String}
	###

	BEM::buildSelector = (selector, prefix) ->
		`var prefix`
		if prefix != ''
			prefix = prefix or '.'
		if typeof selector == 'object'
			if selector.block != undefined
				buildSelector = @buildBlockClass(selector.block)
				if selector.elem != undefined
					buildSelector = @buildElemClass(buildSelector, selector.elem)
				if selector.mod != undefined
					mod = selector.mod.split(':')
					buildSelector = @buildModClass(buildSelector, mod[0], mod[1])
		if buildSelector != undefined then prefix + buildSelector else prefix + selector

	###*
	# Build class name for block.
	# @protected
	#
	# @param {Object|String} $this
	# @param {Number} [index]
	# @return {String}
	###

	BEM::getBlockClass = ($this, index) ->
		`var index`
		blockClasses = @extractBlocks($this)
		index = index or 0
		if index <= blockClasses.length - 1 then blockClasses[index] else null

	###*
	# Get base class from element.
	# @protected
	#
	# @param {Object} $this
	# @return {String}
	###

	BEM::getBaseClass = ($this) ->
		self = this
		baseClass = null
		selectors = @getClasses($this)
		$.each selectors, (i, sel) ->
			classType = self.getClassType(sel)
			if classType and classType != 'mod'
				baseClass = sel
			return
		baseClass

	###*
	# Get class type.
	# @protected
	#
	# @param {String} className
	# @return {String}
	###

	BEM::getClassType = (className) ->
		if @modClassRe.test(className)
			return 'mod'
		else if @elemClassRe.test(className)
			return 'elem'
		else if @blockClassRe.test(className)
			return 'block'
		null

	###*
	# Create BEM instance.
	###

	$.BEM = new BEM(
		namePattern: '[a-zA-Z0-9-]+'
		elemPrefix: '__'
		modPrefix: '--'
		modDlmtr: '_')

	###*
	# Extend jQuery object.
	###

	$.fn.extend
		block: ->
			$.BEM.getBlock this
		elem: (elemKey) ->
			$.BEM.findElem this, elemKey
		ctx: (block, elem) ->
			$.BEM.switchBlock this, block, elem
		mod: (modKey, modVal) ->
			if typeof modVal == 'undefined'
				modVal = null
			if modVal == false
				return $.BEM.delMod(this, modKey)
			if modVal != null
				$.BEM.setMod(this, modKey, modVal)
			else
				$.BEM.getMod(this, modKey)
		setMod: (modKey, modVal) ->
			$.BEM.setMod this, modKey, modVal
		delMod: (modKey, modVal) ->
			$.BEM.delMod this, modKey, modVal
		hasMod: (modKey, modVal) ->
			$.BEM.hasMod this, modKey, modVal
		byMod: (modKey, modVal) ->
			$.BEM.byMod this, modKey, modVal
		byNotMod: (modKey, modVal) ->
			$.BEM.byMod this, modKey, modVal, 'inverse'
		toggleMod: (modKey, modVal1, modVal2) ->
			if @hasMod(modKey, modVal1)
				@delMod(modKey, modVal1).setMod modKey, modVal2
			else
				@delMod(modKey, modVal2).setMod modKey, modVal1
	return
) jQuery