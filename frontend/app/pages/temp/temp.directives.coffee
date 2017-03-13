
module.exports = angular.module('app')

.directive('tempDirective', ['APP','Api','$rootScope', (APP,Api,$rootScope) -> 

	restrict: 'A'
	# controller: ($scope) ->
	link: (scope, el, attr, ctrl, transclude) ->


		return

])
