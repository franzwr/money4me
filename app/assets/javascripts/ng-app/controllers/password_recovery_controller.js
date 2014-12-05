angular.module('money4me.controllers')

.controller('PasswordRecoveryCtrl', ['$rootScope', '$scope', '$http', 'usSpinnerService',
	 function ($rootScope, $scope, $http, usSpinnerService) {

	$scope.recover = function (user) {
		usSpinnerService.spin('spinner');
		$http.post('http://localhost:3000/recover', angular.toJson(user))
			.success(function (data, status) {
				alert(angular.toJson(data));
				if(status == 200) {
					usSpinnerService.stop('spinner');
					$rootScope.addAlert({
						type: 'success',
						msg: 'Se ha enviado la petición. Espere el correo de confirmación y siga las instrucciones.'
					});
				} else {
					usSpinnerService.stop('spinner');
					if(data.success) {
						$rootScope.addAlert({
							type: 'danger',
							msg: 'El usuario indicado no existe o ya tiene una petición de recuperación de contraseña activa.'
						});
					}
					else {
						$rootScope.addAlert({
							type: 'warning',
							msg: 'Recaptcha incorrecto. Ingrese nuevamente los datos.'
						});
					}
				}
			})
			.error(function (data, status) {
				alert(angular.toJson(data));
				usSpinnerService.stop('spinner');
				$rootScope.addAlert({
					type: 'danger',
					msg: 'Ha ocurrido un error. Verifique los datos ingresados o intente más tarde.'
				});
			});
	};

}]);