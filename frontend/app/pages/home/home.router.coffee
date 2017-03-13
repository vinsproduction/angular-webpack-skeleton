
app = angular.module('app')

app.config (stateProvider) ->


	stateProvider.state 'app.page.home',

		url: '/home'

		onEnter: ['$timeout','$stateParams','ngDialog',($timeout,$stateParams,ngDialog)->

		]

		views:

			'content@app.page':
				controller: 'homeCtrl as vm'
				templateProvider: ['$q' , ($q) ->
					deferred = $q.defer()
					require.ensure([], (require) ->
						require("./home.styl")
						template = require('./home.pug')()
						deferred.resolve(template)
					)
					return deferred.promise
				]


		resolve:

			controller: ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./home.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.controller)
				)			
				return deferred.promise
			]

			directive: ['auth','$q','$ocLazyLoad',(auth,$q,$ocLazyLoad) ->
				deferred = $q.defer()
				require.ensure([], ->
					module = require("./home.directives.coffee")
					$ocLazyLoad.load({ name: module.name })
					deferred.resolve(module.directive)
				)			
				return deferred.promise
			]




