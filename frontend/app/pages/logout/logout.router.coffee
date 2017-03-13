
app = angular.module('app')

app.config (stateProvider) ->

	stateProvider.state 'app.page.logout',

		url: '/logout'

		auth: false

		views:

			'content@app.page':

				templateProvider: ['$q' , ($q) ->
					deferred = $q.defer()
					require.ensure([], (require) ->
						require("./logout.styl")
						template = require('./logout.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]


		resolve:

			logout:	['User','$q','$timeout',(User,$q,$timeout) ->

				deferred = $q.defer()

				User.logout()
					.error (res) ->
						deferred.resolve()
					.success (res) ->
						console.debug '[redirect from logout]'
						deferred.reject({redirect: true})

				return deferred.promise
			]
