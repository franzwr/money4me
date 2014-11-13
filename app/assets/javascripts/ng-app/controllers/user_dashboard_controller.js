angular.module('money4me.controllers')

// User Dashboard controller. 
.controller('UserDashboardCtrl', ['$rootScope', '$scope', '$http', 'usSpinnerService', '$location',
	function ($rootScope, $scope, $http, usSpinnerService, $location) {

	$scope.activeBills = $rootScope.currentUser.unpaid_bills;

}]);