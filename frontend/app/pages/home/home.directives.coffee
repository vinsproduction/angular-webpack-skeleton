module.exports = angular.module('app')

.directive 'homeDirective', ['APP','Api','$rootScope', (APP,Api,$rootScope) -> 

	restrict: 'A'
	link: (scope, el, attr, ctrl, transclude) ->

		el = $(el)


		return

]


