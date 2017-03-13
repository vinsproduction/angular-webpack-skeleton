

# ______ Angular  ______

require('angular')
require('oclazyload')
require('angular-ui-router')
require('ui-router-extras')
require('angular-ui-notification' )
require('ng-dialog')
require('angular-cookies')


app = angular.module('app', [

	'ngCookies'
	'ui-notification'
	'oc.lazyLoad'
	'ui.router'
	'ct.ui.router.extras'
	'ngDialog'

])


# ______ App init ______


angular.element(document).ready ->
	angular.bootstrap document, ['app']

# ____ App constans ____

app.constant('APP',

	tempMode: false # Заглушка

	avatar: ''

	debug: do ->
		if /debug/.test(window.location.search)
			obj = 
				auth:  /\^?debug=auth/.test(window.location.search)
				form:  /\^?debug=form/.test(window.location.search)
				test:  /\^?debug=test/.test(window.location.search)

		else
			obj = false
		return obj

	dev: 	/dev\.test\.dev\.ailove\.ru/.test(window.location.host)
	local: 	_.isEmpty(window.location.host) or /localhost/.test(window.location.host)
	host: 	window.location.protocol + "//" + window.location.host



)

# _______ App run ______

app.run(['APP','$rootScope','$timeout','Notification','$state','ngDialog','Storage','User',(APP,$rootScope,$timeout,Notification,$state,ngDialog,Storage,User) ->

	# Блокируем консоль если не локал и не дев и не дебаг
	window.disableConsole() if !APP.local and !APP.dev and !APP.debug

	# Storage.clear()
	dateSet = Storage.get('dateSet')
	# Очищаем локал сторадж если с момента установки прошло более чем 1 день
	if dateSet and Date.parse(dateSet) < (new Date() - 1000*60*60*24*1)
		# Очищаем локал сторадж
		Storage.clearAll()

	if md.mobile()
		$rootScope.browserMode = 'mobile-mode'
	else
		$rootScope.browserMode = 'desktop-mode'

	window.console.groupCollapsed "[App] init"

	window.console.log "[user agent]", md.ua
	window.console.log "[browser mode]", $rootScope.browserMode
	window.console.log "[app constants]", {APP: APP}
	window.console.log "[session storage]", {name: Storage.name, data:Storage.getAll()}
	window.console.log "[local storage]", {name: Storage.name, data:Storage.getAll(true)}

	# Route Map
	routeMap = {}
	_.each $state.get(), (state) ->
		routeMap[state.name] = state
	window.console.log "[route map]", {states: routeMap}

	window.console.groupEnd()

	# ngDialog.open
	# 	template: '<p>my template</p>',
	# 	plain: true


	# Выключаем заглушку для дебага (если она есть)
	APP.tempMode = false if /debug/.test(window.location.search)


	# ___ APP Commons $rootScope ___

	$rootScope._ = _
	$rootScope.parseInt = parseInt
	$rootScope.isEmpty 	= _.isEmpty
	$rootScope.size 		= _.size

	$rootScope.declOfViews 	= (val) -> APP.declOfNum(val, ['просмотр', 'просмотра', 'просмотров'])



# ___ APP Commons func ___

	APP.declOfNum = (number, titles) ->
		cases = [2, 0, 1, 1, 1, 2]
		titles[if number % 100 > 4 and number % 100 < 20 then 2 else cases[if number % 10 < 5 then number % 10 else 5]]

])



# ___ App Settings ___

require("./app.config.coffee")
require("./app.services.coffee")
require("./app.directives.coffee")
require("./app.router.config.coffee")
require("./app.router.coffee")

require("./popups/popups.coffee")


# ____ Services ____

require("services/storage.coffee")
require("services/user.coffee") # Authentication User

