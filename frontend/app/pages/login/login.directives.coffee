module.exports = angular.module('app')

.directive 'loginDirective', ['APP','Api','$rootScope','User','Storage','$state','$timeout',(APP,Api,$rootScope,User,Storage,$state,$timeout) -> 

	restrict: 'A'
	link: (scope, el, attr, ctrl, transclude) ->

		form = $(el)

		return

]