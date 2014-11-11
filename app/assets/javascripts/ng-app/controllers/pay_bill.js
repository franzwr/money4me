angular.module('money4me.controllers')

.controller('PayBillCtrl', ['$http', '$scope', '$rootScope', function ($http, $scope, $rootScope) {
	$scope.fetched = false;
	$scope.payment = {
		rut: "",
		bill: ""
	};

	$scope.fetch = function (payment) {
		if(payment.rut == "" || payment.bill == "") {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Ingrese todos los campos requeridos.'
			});
			return;
		}
		$http.get("http://localhost:3000/api/cuenta?id_propio_empresa=" + payment.bill)
		.success(function(data, status) {
			if(status == 200 && data.rut_cliente == payment.rut) {
				$scope.bill = data;
				$scope.fetched = true;
			}
		})
		.error(function(data, status) {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'No se encontro la cuenta indicada. Verifique que los datos ingresados sean correctos.'
			});
		});
	};
}]);