
app = angular.module('app')

app.config (stateProvider) ->

	stateProvider.state 'app.page.404',

		url: '/404'

		auth: false

		onEnter: ['$rootScope','$timeout',($rootScope,$timeout) ->

		]

		views:

			'content@app.page':

				templateProvider: ['$q' , ($q) ->
					deferred = $q.defer()
					require.ensure([], (require) ->
						require("./404.styl")
						template = require('./404.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]


