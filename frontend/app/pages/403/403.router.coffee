
app = angular.module('app')

app.config (stateProvider) ->

	stateProvider.state 'app.page.403',

		url: '/403'

		auth: false

		params:
			error: ''

		onEnter: ['$rootScope','$timeout',($rootScope,$timeout) ->

		]

		views:

			'content@app.page':

				templateProvider: ['$q' , ($q) ->
					deferred = $q.defer()
					require.ensure([], (require) ->
						require("./403.styl")
						template = require('./403.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]


