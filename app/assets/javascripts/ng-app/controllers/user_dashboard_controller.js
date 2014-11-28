angular.module('money4me.controllers')

// User Dashboard controller. 
.controller('UserDashboardCtrl', ['$rootScope', '$scope', '$http', 'usSpinnerService', '$location', 'Auth', 
	function ($rootScope, $scope, $http, usSpinnerService, $location, Auth) {

	Auth.currentUser().then( function (user) {
		if(user["type"] != "Client") {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Debe identificarse como cliente para ingresar a esta página.'
			});
			$location.path('/');
		}
	} , function (error) {
		$rootScope.addAlert({
			type: 'danger',
			msg: 'Debe identificarse como cliente para ingresar a esta página.'
		});
		$location.path('/');
	});

	$scope.activeBills = $rootScope.currentUser.unpaid_bills;
	$scope.payment = [];

	$scope.getTotal = function (bills) {
		var total = 0;

		for(i=0;i<bills.length;i++){
			total += bills[i].monto;
		}
		return total;
	};

	$scope.addBillToPayment = function (index) {
		$scope.payment.push($scope.activeBills[index]);
		$scope.activeBills.unshift(index, 1);
	};

	$scope.removeBillFromPayment = function (index) {
		$scope.activeBills.push($scope.payment[index]);
		$scope.payment.unshift(index, 1);
	};

	$scope.pay = function () {
		var url = 'http://localhost:3000/api/transfer';



	};

	$scope.addAccount = function (account) {
		
	};


}]);