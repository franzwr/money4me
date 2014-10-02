angular.module('AngularRails')
	.controller('HomeCtrl', function ($scope) {
		$scope.things = ['AngularJS', 'Rails 4.1', 'Bootstrap', 'MySQL'];
});