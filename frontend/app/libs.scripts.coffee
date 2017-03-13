
# Console log!

do ->
	method = undefined
	noop = ->
	methods = [
		'assert'
		'clear'
		'count'
		'debug'
		'dir'
		'dirxml'
		'error'
		'exception'
		'group'
		'groupCollapsed'
		'groupEnd'
		'info'
		'log'
		'markTimeline'
		'profile'
		'profileEnd'
		'table'
		'time'
		'timeEnd'
		'timeStamp'
		'trace'
		'warn'
	]
	length = methods.length
	console = window.console = window.console or {}
	while length--
		method = methods[length]
		# Only stub undefined methods.
		if !console[method]
			console[method] = noop
	return


window.disableConsole = ->

	window.console =
		log: ->
		debug: ->
		warn: ->
		info: ->
		error: ->
		groupCollapsed: ->
		groupEnd: ->

	return

# ______  Libs _____


MobileDetect = require('mobile-detect')
window.md = new MobileDetect(window.navigator.userAgent)

# Script loader
window.$script = $script = require("scriptjs");

$ = require('jquery')

window.$ = window.jQuery = $


_  = require('underscore')

window._ = _


# GSAP
require('!!script!node_modules/gsap/src/uncompressed/TweenMax.js')
require('!!script!node_modules/gsap/src/uncompressed/utils/Draggable.js')


# $script([
# 	'https://cdnjs.cloudflare.com/ajax/libs/jquery-ajaxtransport-xdomainrequest/1.0.1/jquery.xdomainrequest.min.js',
# ])


