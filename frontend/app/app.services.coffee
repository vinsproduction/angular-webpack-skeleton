# Services

app = angular.module('app')

###
	Api

	Api({ method: 'POST', url:"email", data: {email: 'example.com'}})
		.error (res) -> console.error res
		.success (res) ->
			return if res.status isnt 'success'
###

app.factory "Api", ['Http','APP','$state','$timeout','$rootScope','Notification','$injector',(Http,APP,$state,$timeout,$rootScope,Notification,$injector) ->

	request = (options={}) ->

		log = options.log || APP.local # Логировать запросы

		options.url = '/api/' + options.url

		# options.xsrfHeaderName = 'X-CSRFToken'
		# options.xsrfCookieName = 'csrftoken'

		options.data = {} if !options.data

		request = Http(options)

		request.success (response, status, headers, config) ->


			if !(/api\/user\/current/.test(config.url) and config.method is "GET")

				if log
					console.debug "[API #{config.method} #{status}] #{config.url}\r\n config:", {data: (if !_.isEmpty(config.data) then config.data else null), params: (if !_.isEmpty(config.params) then config.params else null)}, "\r\n success:", response
			
			# else if (/api\/user\/profile\/edit/.test(config.url) and config.method is "GET")
			# 	# auth success


		request.error (response, status, headers, config) ->

			if !(/api\/user\/current/.test(config.url) and status is 403 and config.method is "GET")

				if status is 403 and !APP.debug.auth
					if log
						console.error "[API #{config.method} #{status}][LOGOUT REDIRECT] #{config.url}"
					
					User = $injector.get('User')
					User.logoutAfter()

					return

				if status not in [400,403]
					if log then console.error "[API #{config.method} #{status}] #{config.url}"
					
				 	# Подробные ошибки показываем только на деве и локалхосте
					if response and (APP.local or APP.dev or APP.debug)

						if !_.isObject(response) and !_.isArray(response)
							h = response.match(/<h1>(.*?)<\/h1>/ig)
							p = response.match(/<pre>(.*?)<\/pre>/ig)
							if h and h[0]
								resText = $(h[0]).text()
							else if p and p[0]
								resText = $(p[0]).text()
							else
								resText = response
						else
							resText = JSON.stringify(response)

						if resText?
							resText = resText.substr(0,300) + '...'
						else
							resText = "Unknown error"

						if config.method isnt 'GET'

							$rootScope.mainPreloader = false

							Notification.error
								delay: null
								title: "Server error #{status} #{config.method} #{config.url}"
								message: """
									<p>#{resText}</p>
									<p><b>Попробуйте повторить попытку</b></p>
								"""
							
						else

							Notification.error
								delay: null
								title: "Server error #{status} #{config.method} #{config.url}"
								message: """
									<p>#{resText}</p>
									<p><b><a href="#" onclick="window.location.reload();return false;">Перезагрузить страницу</a></b></p>
								"""

					
					else

						if config.method isnt 'GET'

							$rootScope.mainPreloader = false

							Notification.error
								title: 'Ошибка сервера'
								replaceMessage:  true
								message: """
									Попробуйте повторить попытку
								"""

						else

							Notification.error
								replaceMessage:  true
								closeOnClick: false
								delay: null
								title: 'Ошибка сервера'
								message: """
									<a href="#" onclick="window.location.reload();return false;">Перезагрузить страницу</a>
								"""

				else
					if log
						console.error "[API #{config.method} #{status}] #{config.url}\r\n config:", {data: (if !_.isEmpty(config.data) then config.data else null), params: (if !_.isEmpty(config.params) then config.params else null)}, "\r\n error:", response

			
		return request

	return request

]

###
	Обертка для $http
	Http({url:'/'}).success((res) -> ).error((res) -> )
###


app.factory "Http", ['$http', 'APP', ($http, APP) ->

	defaultOptions =

		url: ""
		method: 'GET'
		headers: {}
		data: {}

	request = (options={}) ->

		params = angular.extend({},defaultOptions,options)
		
		request = $http(params)

		request.success (response, status, headers, config) ->
			
		request.error (response, status, headers, config) ->

		return request


	return request

]

