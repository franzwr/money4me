angular.module('money4me.controllers')

.controller('SignUpCtrl', ['$scope', '$location', '$rootScope', 'Auth', 'usSpinnerService',
 function ($scope, $location, $rootScope, Auth, usSpinnerService) {

	$scope.user = {};
	
	$scope.sign_up = function(user) {
		usSpinnerService.spin('spinner');
		Auth.register(user).then(function(response) {
			$rootScope.addAlert({
				type: 'success',
				msg: "Registro Exitoso. Se ha enviado un correo de confimación a" + response.email 
			});
			usSpinnerService.stop('spinner');
			$location.path('/'); 
		}, function(error) {
			var err = "No se logró completar el registro. "
			if(error.data.errors.email) {err += "El correo se encuentra en uso. ";}
			if(error.data.errors.rut) {err += "El RUT se encuentra en uso. ";}
			if(error.data.errors.password_confirmation) {err += "Las contraseñas no coinciden. ";}
			$rootScope.addAlert({
				type: 'danger',
				msg: err
			}, true);
			usSpinnerService.stop('spinner');
		});
	}
}]);