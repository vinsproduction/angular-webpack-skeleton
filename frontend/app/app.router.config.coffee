app = angular.module('app')


# _________ stateProvider ___________

app.provider 'state', (APP,$stateProvider) ->

	@state = (name, state) ->

		# Выключаем роуты если стоит зашлушка, оставляя только необходимые
		return if APP.tempMode and name not in ['app.page.temp','app.page.403','app.page.404']

		@set(name,state)

		$stateProvider.state(name, state)

	@$get = ->

	@set = (name,state) ->

		# Настройки по-умолчанию

		state.auth = false if !state.auth? # Включить проверку авторизации

		state.inherit = false if !state.inherit?	

		state.preloader = true if !state.preloader?

		state.access = 'auth' if !state.access?

		state.header = 1 if !state.header?
		state.footer = 1 if !state.footer?
		state.summary = true if !state.summary?

		state.params = {} if !state.params
		state.views = {} if !state.views
		state.resolve = {} if !state.resolve
		state.views['popups@app'] = {} if !state.views['popups@app']

		isPopup = /app\.popup/.test(name)

		# Resolves! (Ставится только у родителей)
		return if state.inherit

		# Сервис предыдущего стейта (только страницы)
		if !state.resolve.previousState
			state.resolve.previousState = ['$previousState','$stateParams',($previousState,$stateParams) ->
				
				pagesPrevState = $previousState.get('pagesPrevState')
				prevState = if pagesPrevState then pagesPrevState.state else null
				# console.log '[pages previous state]', prevState
				return prevState
			]


		# Проверка авторизации

		# Уровень доступа 'public' - страница доступна всем!

		# Уровень доступа 'guest' - страница доступна ТОЛЬКО НЕ авторизованному пользователю!
		# Если он авторизован, его пробросит на home!
		# Если Не авторизован, страница откроется

		# Уровень доступа 'auth'  - страница доступна ТОЛЬКО авторизованному пользователю!
		# Если он авторизован, страница откроется
		# Если Не авторизован, его пробросит на login!

		# *По-умолчанию уровень доступа 'auth'



		state.resolve.auth = ['APP','User','$q','$state','$previousState','$timeout','Notification','$rootScope','Storage','ngDialog',(APP,User,$q,$state,$previousState,$timeout,Notification,$rootScope,Storage,ngDialog) ->

			if !state.auth

				if state.access is 'guest'
					$q.reject('access denied')

				return null

			if APP.debug.auth
				return User.testInfo()

			deferred = $q.defer()

			User.get()

				# Авторизован
				.success (res) ->

					user = res.data

					$rootScope.user = user

					console.debug "[auth success: #{user.email}]", {auth: user}

					switch state.access

						when 'guest'

							deferred.reject({redirect:true})

							authPrevState = $previousState.get('authPrevState')
							prevState = if authPrevState then authPrevState.state else null

							if prevState and prevState.name
								redirect = prevState.name
								console.debug '[redirect from previous state] ' + name + ' → ' + redirect

							else
								redirect = 'app.page.home'	
								console.debug '[redirect] ' + name + ' → ' + redirect

							$timeout -> $state.go(redirect,{},{reload:true})

						when 'public'

							deferred.resolve(user)

						when 'auth'

							deferred.resolve(user)

							if !isPopup # для попапов нет необходимости в предыдущих стейтах
								$previousState.set('authPrevState',name)
								Storage.set('authPrevState',name)

					return

				# Не авторизован
				.error (err,status) ->

					err = angular.copy(err)

					if status is 403

						console.error "[auth logout]"

						switch state.access

							when 'guest'

								deferred.resolve(null)

							when 'public'

								deferred.resolve(null)

							when 'auth'

								deferred.reject({redirect:true})

								User.logoutAfter()

					else
						console.error "[auth server error]"
						deferred.reject({authServerError:true})

					return

			return deferred.promise

		]

		if state.header

			if state.header is 1

				state.views['header@app.page'] =

					controller: 'headerCtrl as vm'
					templateProvider: ['$q',($q) ->
						deferred = $q.defer()
						require.ensure([], (require) ->
							require('partials/header/header.styl')
							template = require('partials/header/header.pug')()
							deferred.resolve(template)
						)
						return deferred.promise
					]

				state.resolve['headerController'] = ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->

					deferred = $q.defer()
					require.ensure([], ->
						module = require("partials/header/header.coffee")
						$ocLazyLoad.load({ name: module.name })
						deferred.resolve(module.controller)
					)			
					return deferred.promise
				]

				# state.resolve['headerDirective'] =	['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->

				# 	deferred = $q.defer()
				# 	require.ensure([], ->
				# 		module = require("partials/header-1/header.directives.js")
				# 		$ocLazyLoad.load({ name: module.name })
				# 		deferred.resolve(module.directive)
				# 	)			
				# 	return deferred.promise
				# ]

		if state.footer

			if state.footer is 1

				state.views['footer@app.page'] =

					templateProvider: ['$q',($q) ->
						deferred = $q.defer()
						require.ensure([], (require) ->
							require('partials/footer/footer.styl')
							template = require('partials/footer/footer.pug')()
							deferred.resolve(template)
						)
						return deferred.promise
					]


				# state.resolve['footerDirective'] =	['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->

				# 	deferred = $q.defer()
				# 	require.ensure([], ->
				# 		module = require("partials/footer/footer.directives.js")
				# 		$ocLazyLoad.load({ name: module.name })
				# 		deferred.resolve(module.directive)
				# 	)			
				# 	return deferred.promise
				# ]

		return

	return


# _____________ Events  _____________

app.run ['APP','$rootScope','$state','$timeout','Notification','$previousState',(APP,$rootScope,$state,$timeout,Notification,$previousState) ->

	$rootScope.$on '$stateChangeError', (evt, toState, toParams, fromState, fromParams, error) ->
		
		# $rootScope.mainPreloader = false

		evt.preventDefault()

		if error and !error.redirect

			console.error '[state error] ', error

		return

	$rootScope.$on '$stateChangeStart', (evt,toState,toParams,fromState,fromParams,options) ->

		# Редирект если в стейте redirectTo
		if toState.redirectTo
			evt.preventDefault()
			$state.go(toState.redirectTo, toParams)
			return

		$rootScope.mainPreloader = toState.preloader

		console.debug "[state start] → #{toState.name}", {params:toParams,state:toState}

		return

	$rootScope.$on '$stateChangeSuccess', (evt,toState,toParams,fromState,fromParams,options) ->

		# Notification.clearAll()

		# $timeout(->
		$rootScope.mainPreloader = false
		# ,500)

		$rootScope.popupIsOpen = false

		$rootScope.state = toState
		$rootScope.stateName = toState.name
		$rootScope.stateParams = toParams

		if /app\.popup/.test(toState.name)
			$rootScope.popupName = toState.name.replace(/app\.popup\./,'').replace(/\./g,'-')

			# сохраняем предыдущее состояние попапа
			$previousState.set('popupsPrevState', toState.name)
			
		if /app\.page/.test(toState.name)
			$rootScope.pageName = toState.name.replace(/app\.page\./,'').replace(/\./g,'-')

			# сохраняем предыдущее состояние страницы
			$previousState.set('pagesPrevState', toState.name)

			# Reset styles
			$rootScope.bodyId = ""
			$rootScope.bodyClass = ""
			$rootScope.mainClass = ""


		console.log "[state finish] #{fromState.name} → #{toState.name}\r\n\r\n"
		return

	$rootScope.$on '$stateNotFound', (evt,unfoundState, fromState, fromParams) ->
		console.error '[state] ' + unfoundState.to + ' not found'
		return

	$rootScope.$on '$viewContentLoaded', (evt,viewName) ->
		# console.log '[state view] ' + viewName + ' loaded'
		return

	return

]


