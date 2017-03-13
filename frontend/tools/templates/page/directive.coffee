
module.exports = angular.module('app')

.directive('[pageName]Directive', ['APP','Api','$rootScope', (APP,Api,$rootScope) -> 

	restrict: 'A'
	# controller: ($scope) ->
	link: (scope, el, attr, ctrl, transclude) ->


		return

])