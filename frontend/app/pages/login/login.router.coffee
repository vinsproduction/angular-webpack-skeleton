
app = angular.module('app')

app.config (stateProvider) ->

	stateProvider.state 'app.page.login', 

		access: 'guest'

		url: '/login'

		onEnter: ['$rootScope','$timeout',($rootScope,$timeout) ->

		]

		views:

			'content@app.page':
				controller: 'loginCtrl as vm'
				templateProvider: ['$q' , ($q) ->
					deferred = $q.defer()
					require.ensure([], ->
						require("./login.styl")
						template = require('./login.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]

		resolve:

			controller: ['auth','$q','$ocLazyLoad', (auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./login.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.controller)
				)			
				return deferred.promise
			]

			directive: ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./login.directives.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.directive)
				)			
				return deferred.promise
			]

