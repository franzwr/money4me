angular.module('money4me.controllers')

// User Dashboard controller. 
.controller('UserDashboardCtrl', ['$rootScope', '$scope', '$http', 'usSpinnerService', '$location',
	function ($rootScope, $scope, $http, usSpinnerService, $location) {

	$scope.activeBills = $rootScope.currentUser.unpaid_bills;

	$scope.getTotal = function (bills) {
		var total = 0;

		for(i=0;i<bills.length;i++){
			total += bills[i].monto;
		}
		return total;
	};

}]);