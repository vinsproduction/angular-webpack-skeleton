
module.exports = angular.module('app')

.directive('devDirective', ['APP','Api','$rootScope', (APP,Api,$rootScope) -> 

	restrict: 'A'
	# controller: ($scope) ->
	link: (scope, el, attr, ctrl, transclude) ->


		return

])
