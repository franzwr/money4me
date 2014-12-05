angular.module('money4me.controllers')

/** Defines all User Dashboard related tasks. */
.controller('UserDashboardCtrl', ['$rootScope', '$scope', '$http', 'usSpinnerService', '$location', 'Auth', '$window', '$filter',
	function ($rootScope, $scope, $http, usSpinnerService, $location, Auth, $window, $filter) {

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

	$scope.accounts = $rootScope.currentUser.accounts;
	$scope.activeBills = angular.copy($rootScope.currentUser.unpaid_bills);
	$scope.payment = [];

	if($rootScope.currentUser.accounts.length > 0) {
		$scope.currentAccount = $scope.accounts[0].id_cuenta_banco;
	}

	/** Calculates the total amount given a set of bills. */
	$scope.getTotal = function (bills) {
		var total = 0;

		for(i=0;i<bills.length;i++){
			total += bills[i].monto;
		}
		return total;
	};

	/** Adds a bill to the payment and removes it from the active bills. */
	$scope.addBillToPayment = function (index) {
		$scope.payment.push($scope.activeBills[index]);
		$scope.activeBills.splice(index, 1);
		$rootScope.addAlert({
			type: 'success',
			msg: "La cuenta ha sido agregada. Para realizar el pago dirigirse a Pagar Cuentas, o puede agregar más cuentas."
		});
	};

	/** Adds a bill to actives bills and removes it from the payment. */
	$scope.removeBillFromPayment = function (index) {
		$scope.activeBills.push($scope.payment[index]);
		$scope.payment.splice(index, 1);
		$rootScope.addAlert({
			type: 'success',
			msg: "La cuenta se ha eliminado del pago."
		});
	};

	/** Performs the payment of all bills added by the user. */
	$scope.pay = function () {
		if(angular.isUndefined($scope.currentAccount)) {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Seleccione una cuenta bancaria. Puede agregar más en su Perfil.'
			});
		} else {
			usSpinnerService.spin('spinner1');
			var url = 'http://localhost:3000/api/multi_transfer';
			var data = {
				payment: {
					id_cuenta_banco: $scope.currentAccount,
					detalle: $scope.comments,
					fecha_pago: $filter('date')(Date.now(), 'yyyy-MM-dd HH:mm:ss Z', '-0300'),
					rut_cliente: $rootScope.currentUser.rut,
					email: $rootScope.currentUser.email
				},
				bills: $scope.payment,
				account: $scope.currentAccount,
				total: $scope.getTotal($scope.payment)
			};
			$http.post(url, angular.toJson(data))
				.success(function (data, status) {
					usSpinnerService.stop('spinner1');
					if(status == 200) {
						$rootScope.currentUser = data;
						$window.localStorage["Session"] = angular.toJson(data);
						$scope.payment = [];
						$scope.accounts = $rootScope.currentUser.accounts;
						$scope.activeBills = $rootScope.currentUser.unpaid_bills;
						$rootScope.addAlert({
							type: 'success',
							msg: 'Las transacciones se realizaron con éxito.'
						}); 
					} else {
						$rootScope.addAlert({
							type: 'danger',
							msg: data.error
						}); 
					}
				})
				.error(function (data, status) {
					usSpinnerService.stop('spinner1');
					$rootScope.addAlert({
						type: 'danger',
						msg: data.error
					}, true); 
				});
		}
	};

	/** Adds a bank account to the user profile, after performing verifications. */
	$scope.addAccount = function (account_number) {
		usSpinnerService.spin('spinner1');
		var account = {
			id_cuenta_banco: account_number,
			rut: $rootScope.currentUser.rut
		};

		$http.post('http://localhost:3000/api/account/', angular.toJson(account))
			.success(function (data, status) {
				usSpinnerService.stop('spinner1');
				console.log(data);
				if(status == 200) {
					$rootScope.currentUser.accounts = data;
					$window.localStorage["Session"] = angular.toJson($rootScope.currentUser);
					$rootScope.addAlert({
						type: 'success',
						msg: 'La cuenta bancaria se agrego correctamente.'
					});
				} else {
					$rootScope.addAlert({
						type: 'danger',
						msg: 'La cuenta bancaria no existe o le pertenece a otro usuario.'
					});
				}
			})
			.error(function (data, status) {
				usSpinnerService.stop('spinner1');
				if (status == 404) {
					$rootScope.addAlert({
						type: 'danger',
						msg: 'La cuenta bancaria no existe o le pertenece a otro usuario.'
					});
				} else {
					$rootScope.addAlert({
						type: 'danger',
						msg: 'Ha ocurrido un error. Intente mas tarde.'
					});
				}
			});
	};

	/** Request a password change, making it visible to admins. */
	$scope.requestPasswordChange = function () {
		usSpinnerService.spin('spinner1');
		var url = 'http://localhost:3000/request_password_change';

		$http.get(url)
			.success(function (data, status) {
				usSpinnerService.stop('spinner1');
				if(status == 200) {
					$rootScope.addAlert({
						type: 'success',
						msg: 'La petición ha sido enviada. Un administrador debe validar la petición. Se le enviará un correo cuando esto ocurra.'
					}, true);
				}
			})
			.error(function (data, status) {
				usSpinnerService.stop('spinner1');
				$rootScope.addAlert({
					type: 'danger',
					msg: 'Una petición ya se encuentra en proceso. Revise su correo.'
				}, true);		
			});
	};

}]);