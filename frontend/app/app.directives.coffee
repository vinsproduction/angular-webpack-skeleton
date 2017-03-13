
app = angular.module('app')


app.directive 'showDelay', ['$rootScope', '$timeout', ($rootScope, $timeout) ->

	restrict: 'A'
	link: (scope, el, attr) ->
		el = $(el)
		delay = attr.showDelay || 0.8
		TweenMax.set(el, {opacity:0,transition:'none'})
		TweenMax.to(el, delay, {opacity:1,ease: Quad.easeInOut})
		return

]

app.directive 'showCenter', ['$rootScope', '$timeout', ($rootScope, $timeout) ->

	restrict: 'A'
	link: (scope, el, attr) ->
		el = $(el)


		TweenMax.set el, 
			position:'absolute'
			left:"50%"
			top:"50%"
			x: "-50%"
			y: "-50%"

		$timeout ->

			borderBox = el.css('box-sizing') and el.css('box-sizing') is 'border-box'

			leftRight = parseInt(el.css('padding-left')) + parseInt(el.css('padding-right'))
			topBottom = parseInt(el.css('padding-top')) + parseInt(el.css('padding-bottom'))

			if el.css('width')
				elWidth = parseInt(el.css('width'))
			else
				elWidth = el.outerWidth()

			if el.css('height')
				elHeight = parseInt(el.css('height'))
			else
				elHeight = el.outerHeight()

			if !borderBox
				elWidth -= leftRight
				elHeight -= topBottom

			if elHeight%2
				elHeight += 1
				TweenMax.set(el,{height: elHeight})

			if elWidth%2
				elWidth += 1
				TweenMax.set(el,{width: elWidth})

			return

]


app.directive 'pre',  ->

	restrict: 'E'
	link: (scope, el, attr, ctrl, transclude) ->

		el = $(el)
		if !el.hasClass('i')
			el.click -> $(@).hide()

		return