angular.module('money4me.controllers')
	.controller('HomeCtrl', ['$scope' ,function($scope) {
		$scope.things = ['AngularJS', 'Rails 4.1', 'Bootstrap', 'MySQL'];
	}]);