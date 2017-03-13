app = angular.module('app')

# _________ Base routes ___________

app.config (APP,$urlRouterProvider,$locationProvider,$stateProvider,$urlMatcherFactoryProvider,stateProvider) ->


	$urlMatcherFactoryProvider.strictMode(false)
	$locationProvider.html5Mode(false).hashPrefix('!')

	if APP.tempMode

		$urlRouterProvider.when('','/temp/')
		$urlRouterProvider.when('/','/temp/')

	else
		$urlRouterProvider.when('','/login/')
		$urlRouterProvider.when('/','/login/')
		$urlRouterProvider.when('/temp','/login/')
	

	$urlRouterProvider.otherwise('/404')


	$stateProvider.state 'app',
		abstract: true
		url: ''
		template: """
			<div ui-view='pages'></div>
			<div ui-view='popups'></div>		
		"""

	$stateProvider.state 'app.page',
		abstract: true
		sticky: true
		url: ''
		views:
			pages:
				template: """
					<div ui-view='header'></div>
					<div ui-view='content'></div>
					<div ui-view='footer'></div>
				"""

	$stateProvider.state 'app.popup',
		abstract: true
		url: ''

# _________ Page routes ___________

require("pages/temp/temp.router.coffee")
require("pages/404/404.router.coffee")
require("pages/403/403.router.coffee")

require("pages/dev/dev.router.coffee")
require("pages/home/home.router.coffee")

# Auth
require("pages/login/login.router.coffee")
require("pages/logout/logout.router.coffee")

