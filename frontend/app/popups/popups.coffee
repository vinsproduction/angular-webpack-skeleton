
app = angular.module('app')

# Set popups scope
app.run ['$rootScope','$state',($rootScope,$state) ->
	$rootScope.popups = {}
]

require('./popups.styl')

require("./popups.directive.coffee")