
app = angular.module('app')

app.config (stateProvider) ->

	stateProvider.state 'app.page.temp',

		url: '/temp'

		auth: false

		onEnter: ['$rootScope','$timeout',($rootScope,$timeout) ->

		]

		views:

			'content@app.page':
				controller: "tempCtrl as vm"
				templateProvider: ['$q',($q) ->
					deferred = $q.defer()
					require.ensure([], (require) ->
						require("./temp.styl")
						template = require('./temp.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]


		resolve:

			controller: ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./temp.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.controller)
				)			
				return deferred.promise
			]

			directive: ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./temp.directives.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.directive)
				)			
				return deferred.promise
			]

			# example: ['auth','Api','$q','$stateParams',(auth,Api,$q,$stateParams) ->
			# 	deferred = $q.defer()
			# 	Api({ method: 'GET', url:"get/example" })
			# 		.error (res) -> deferred.reject(res)
			# 		.success (res) ->
			# 			if res.status is 'success'					
			# 				deferred.resolve(res.data.response)
			# 			else
			# 				deferred.reject(res)
			# 	return deferred.promise
			# ]



