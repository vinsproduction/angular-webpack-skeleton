

app = angular.module('app')

app.factory "User", ['Api','APP','$q','Notification','$rootScope','$timeout','$previousState','$state','Storage',(Api,APP,$q,Notification,$rootScope,$timeout,$previousState,$state,Storage) ->

	auth: null

	get: ->

		self = @

		self.getBefore()

		request = Api({ method: 'GET', url:"user/current" })

		request.error (res) ->

			return if !res

			if res.status is 'error'

				if res.data and _.isArray(res.data)
					_.each res.data (error) ->
						# Notification.error error.message
						console.log '[User::get error]', error

				else if res.data and _.isObject(res.data)
					_.each res.data, (error) ->
						# Notification.error error
						console.log '[User::get error]',error.toString()
				else
					# Notification.error 'Неизвестная ошибка 1'
					console.log '[User::get error]','Неизвестная ошибка 1'

			else

				console.log '[User::get error]','Неизвестная ошибка 2'

			return request

		request.success (res) ->

			return if !res

			if res.status isnt 'success'
				# Notification.error 'Неизвестная ошибка 3'
				console.log '[User::get error]','Неизвестная ошибка 3'

			else

				self.getAfter(res)

			return request	

		return request

	getBefore: (res) ->

	getAfter: (res) ->

		user = res.data

		user.avatar = APP.avatar if !user.avatar

		@auth = user

		return

	login: (data) ->

		self = @

		self.loginBefore()

		request = Api({ method: 'POST', url:"auth/login", data: data})

		request.error (res) ->

			if res.status is 'error'

				if res.data and _.isArray(res.data)
					_.each res.data (error) ->
						# Notification.error error.message
						console.log '[User::login error]', error

				else if res.data and _.isObject(res.data)
					_.each res.data, (error) ->
						# Notification.error error
						console.log '[User::login error]',error.toString()
				else
					# Notification.error 'Неизвестная ошибка 1'
					console.log '[User::login error]','Неизвестная ошибка 1'

			else

				console.log '[User::login error]','Неизвестная ошибка 2'

			return request
		
		request.success (res) ->

			if res.status isnt 'success'
				# Notification.error 'Неизвестная ошибка 3'
				console.log '[User::login error]','Неизвестная ошибка 3'
			else

				self.loginAfter()

			return request	

		return request

	loginBefore: ->

		return

	loginAfter: ->

		return

	logout: ->

		self = @

		self.logoutBefore()

		request = Api({ method: 'POST', url:"auth/logout" })

		request.error (res) ->

			if res.status is 'error'

				if res.data and _.isArray(res.data)
					_.each res.data (error) ->
						# Notification.error error.message
						console.log '[User::logout error]', error

				else if res.data and _.isObject(res.data)
					_.each res.data, (error) ->
						# Notification.error error
						console.log '[User::logout error]',error.toString()
				else
					# Notification.error 'Неизвестная ошибка 1'
					console.log '[User::logout error]','Неизвестная ошибка 1'

			else

				# Notification.error 'Неизвестная ошибка 2'
				console.log '[User::logout error]','Неизвестная ошибка 2'

			return request

		request.success (res) ->

			if res.status isnt 'success'
				# Notification.error 'Неизвестная ошибка 3'
				console.log '[User::logout error]','Неизвестная ошибка 3'
			else

				self.logoutAfter(true)

			return request	

		return request

	logoutBefore: ->

		return

	logoutAfter: (full) ->

		# Сделано для того чтобы вернуться на предыдущую страницу если случайно разлогинило
		authPrevState = Storage.get('authPrevState')
		# Очищаем локал сторадж
		Storage.clearAll() 
		# Сохраняем предыдущий стайте в локал сторадж
		if !full and authPrevState
			Storage.set('authPrevState',authPrevState)

		$timeout(->
			window.location.href = '/'
		,100)

		return


]