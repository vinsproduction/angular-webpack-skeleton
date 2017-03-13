app = angular.module('app')

app.directive('popupsDirective', ['$state','$timeout','$rootScope','$stateParams','$previousState',($state,$timeout,$rootScope,$stateParams,$previousState) ->
	restrict: 'A'
	link: (scope, el, attr, ctrl, transclude) ->

		disableClose = attr.disableClose?
		redirectClose = attr.redirectClose

		pagesPrevState = $previousState.get('pagesPrevState')
		prevState = if pagesPrevState then pagesPrevState.state else null

		el = $(el)

		el
			.wrapInner("<div class='popup-inner'></div>")
			.prepend("<div class='popup-bg'></div>")
		
		bg = el.find('.popup-bg')
		inner = el.find('.popup-inner')

		TweenMax.set(inner, {opacity:0,transition:'none'})

		popupHeight = 0
		popupWidth = 0
		windowWidth = 0
		windowHeight = 0

		$rootScope.popupIsOpen = true

		if !prevState or $stateParams.popupBg
			bg.addClass('without-previous-state')

		position = ->

			popupHeight 	= inner.outerHeight() + parseInt(inner.css('margin-top')) + parseInt(inner.css('margin-bottom'))
			popupWidth 		= parseInt(inner.css('min-width')) || inner.outerWidth()

			windowWidth 	= if window.innerWidth? then window.innerWidth else $(window).width()
			windowHeight 	= if window.innerHeight? then window.innerHeight else $(window).height()

			top = windowHeight / 2 - popupHeight / 2 + $(window).scrollTop()
			top = 0 if top < 0
			left = windowWidth / 2 - popupWidth / 2
			left = 0 if left < 0

			css = {}

			css.top 	= top
			css.left 	= left

			if popupWidth > windowWidth
				css.width = windowWidth
			else
				css.width = popupWidth

			inner.css(css)

			el.css
				height: if popupHeight > windowHeight then popupHeight else windowHeight
				# width: windowWidth


		$timeout ->

			position()

			TweenMax.to(inner, 1, {opacity:1,ease:Quad.easeInOut})

			$(window).resize -> $timeout -> position()

			# if popupHeight < windowHeight

			# 	$(window).scroll -> position()

		if redirectClose
			redirect = redirectClose
		else if prevState and prevState.name
			redirect = prevState.name
		else
			redirect = 'app.page.home'

		if !disableClose

			el.on 'click','[popup-close]', ->
				$state.go(redirect,$stateParams)
				# $state.go(redirect,$stateParams,{notify:false})
				# $("[ui-view='popups']").empty()
				return false

			el.click ->
				if !$(event.target).closest(inner).length and !$(event.target).is(inner)
					$state.go(redirect,$stateParams)
					# $state.go(redirect,$stateParams,{notify:false})
					# $("[ui-view='popups']").empty()
				return
			

])
