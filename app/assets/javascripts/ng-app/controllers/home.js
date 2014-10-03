angular.module('AngularRails')
	.controller('HomeCtrl', ['$scope' ,function($scope) {
		$scope.things = ['AngularJS', 'Rails 4.1', 'Bootstrap', 'MySQL'];
	}]);