
angular.module('money4me.controllers')

// Main controller for the payment view. usSpinnerService provides the spinner.
.controller('PayBillCtrl', ['$http', '$scope', '$rootScope', 'usSpinnerService', '$modal', 
	function ($http, $scope, $rootScope, usSpinnerService, $modal) {

	// Form view variables.
	$scope.fetched = false;
	$scope.payment = {
		rut: "",
		bill: ""
	};

	// Gets the bill required by the user if it exists and has not already been payed.
	// Opens the payment modal to finish the transaction.
	$scope.fetch = function (payment) {

		// Require fields to be completed.
		if(payment.rut == "" || payment.bill == "") {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Ingrese todos los campos requeridos.'
			});
			return false;
		}

		usSpinnerService.spin('spinner');

		// HTTP request to the server.
		$http.get("http://localhost:3000/api/cuenta?id_propio_empresa=" + payment.bill)
		.success(function(data, status) {
			// Bill found and belongs to the client.
			if(status == 200 && data.rut_cliente == payment.rut) {
				$scope.bill = data;
				$scope.fetched = true;
				// Opens modal view
				var modalInstance = $modal.open({
					templateUrl: 'payModal.html',
					controller: 'PayModalCtrl',
					size: 'md',
					resolve: {
						bill: function () {
							return $scope.bill;
						}
					}
				});

				// Promise resolved by modal closing.
				modalInstance.result.then(function (status) {
					if(status) {
						$rootScope.addAlert({
							type: 'success',
							msg: 'La transacción se realizó con éxito.'
						});
					} else {
						$rootScope.addAlert({
							type: 'danger',
							msg: 'No se logró realizar la transacción.'
						});
					}
				})
			}
			else {
				$rootScope.addAlert({
					type: 'danger',
					msg: 'No se encontro la cuenta indicada. Verifique que los datos ingresados sean correctos.'
				});	
			}
			usSpinnerService.stop('spinner');
		})
		.error(function(data, status) {
			// Bill not found
			$rootScope.addAlert({
				type: 'danger',
				msg: 'No se encontro la cuenta indicada. Verifique que los datos ingresados sean correctos.'
			});
			usSpinnerService.stop('spinner');
		});
	};
}])

// Controller for the payment modal. modalInstace and bill objects injected from parent controller.
.controller('PayModalCtrl', ['$scope', '$modalInstance', 'bill', '$filter', 'usSpinnerService', '$http',   
	function ($scope, $modalInstance, bill, $filter, usSpinnerService, $http) {

	// Form view variables
	$scope.bill = bill;
	$scope.ready = false;
	$scope.user_comments = "";
	$scope.user_account = "";
	$scope.user_email = "";

	// Checks if the accounts exists, and if it has enough money to make the transaction
	$scope.verify = function () {
		usSpinnerService.spin('spinner1');
		var url = "http://localhost:3000/api/accounts/" + $scope.user_account;
		$http.get(url)
		.success(function (data, status) {
			// Account exists
			if(status == 200) {
				// Has enough money
				if(data.fondo >= $scope.bill.monto) {
					// Belongs to the user
					if(data.rut == $scope.bill.rut_cliente) {
						$scope.info = "La cuenta está activa y el saldo es suficiente.";
						$scope.ready = true;
					} else {
						$scope.info = "La cuenta ingresada no es válida.";
					}
				} else {
					$scope.info = "La cuenta está activa pero sus fondos no son suficientes.";
				}
				usSpinnerService.stop('spinner1');
			}
		})
		.error(function (data, status) {
			// Account does not exists
			$scope.info = "La cuenta no existe o no se encuentra activa.";
			usSpinnerService.stop('spinner1');
		});
	}

	// Performs the payment transaction
	$scope.pay = function () {
		usSpinnerService.spin('spinner2');
		// API call url
		var url = "http://localhost:3000/api/transfer/";
		// Payment object to be passed to the server for Payment instance creation.
		$scope.payment = {
			id_cuenta_banco: $scope.user_account,
			detalle: $scope.user_comments,
			fecha_pago: $filter('date')(Date.now(), 'yyyy-MM-dd HH:mm:ss Z', '-0300'),
			rut_cliente: $scope.bill.rut_cliente,
			email: $scope.user_email
		};
		// JSON object to be passed as the request body.
		var data = angular.toJson({
			origin: parseInt($scope.user_account),
			destination: $scope.bill.empresa.cuenta_banco,
			amount: $scope.bill.monto,
			bill: $scope.bill.id_cuenta,
			payment: $scope.payment 
		});
		// HTTP request
		$http.post(url, data)
		.success(function (data, status) {
			// Transaction successfull
			if(status == 200) {
				usSpinnerService.stop('spinner2');
				$modalInstance.close(data);
			} else {
				// Transaction unsuccessfull
				usSpinnerService.stop('spinner2');
				$modalInstance.close(false);
			}
		})
		.error(function (data, status) {
			// Transaction unsuccessfull
			usSpinnerService.stop('spinner2');
			$modalInstance.close(false);
		});
	};

	// Closes the payment modal
	$scope.cancel = function () {
    	$modalInstance.close(false);
  	};
}]);