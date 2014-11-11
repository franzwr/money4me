angular.module('money4me.controllers')
	.controller('HomeCtrl', ['$scope', '$rootScope' ,function($scope, $rootScope) {
		$scope.things = ['AngularJS', 'Rails 4.1', 'Bootstrap', 'MySQL'];
	}]);