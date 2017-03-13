
angular.module('app')

.config(['APP','$httpProvider','$interpolateProvider', '$sceProvider', '$ocLazyLoadProvider', 'NotificationProvider', '$stickyStateProvider',(APP,$httpProvider,$interpolateProvider, $sceProvider, $ocLazyLoadProvider, NotificationProvider,$stickyStateProvider) ->

	# disable cache IE
	# http://stackoverflow.com/questions/16098430/angular-ie-caching-issue-for-http
	$httpProvider.defaults.headers.get = {} if !$httpProvider.defaults.headers.get
	# disable IE ajax request caching
	$httpProvider.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT'
	# extra
	$httpProvider.defaults.headers.get['Cache-Control'] = 'no-cache'
	$httpProvider.defaults.headers.get['Pragma'] = 'no-cache'

	# $interpolateProvider.startSymbol('[[')
	# $interpolateProvider.endSymbol(']]')
	
	$sceProvider.enabled(false)

	$ocLazyLoadProvider.config 
		debug: APP.local

	# $stickyStateProvider.enableDebug(true)

	# Angular Notification

	NotificationProvider.setOptions
		replaceMessage: true
		maxCount: 10,
		delay: 10000,
		startTop: 20,
		startRight: 10,
		verticalSpacing: 20,
		horizontalSpacing: 20,
		positionX: 'right',
		positionY: 'bottom'

	return

])