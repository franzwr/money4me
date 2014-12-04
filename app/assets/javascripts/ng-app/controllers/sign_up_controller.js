angular.module('money4me.controllers')

// Main controller for the Sign Up view
.controller('SignUpCtrl', ['$scope', '$location', '$rootScope', 'Auth', 'usSpinnerService',
 function ($scope, $location, $rootScope, Auth, usSpinnerService) {
 	// User object
	$scope.user = {
		type: 'Client'
	};
	
	// Users the Auth module to register the user through Devise.
	$scope.sign_up = function(user) {
		usSpinnerService.spin('spinner');
		// HTTP request
		Auth.register(user).then(function(response) {
			// Successfull sign up
			$rootScope.addAlert({
				type: 'success',
				msg: "Registro Exitoso. Se ha enviado un correo de confimación a " + response.email 
			});
			usSpinnerService.stop('spinner');
			// Redirects to home
			$location.path('/'); 
		}, function(error) {
			// Unsuccessfull sign up. Shows all errors throwed by the server.
			var err = "No se logró completar el registro. ";
			if(error.data.errors.email) {err += "El correo se encuentra en uso. ";}
			if(error.data.errors.rut) {err += "El RUT se encuentra en uso. ";}
			if(error.data.errors.password) {err += "La contraseña es muy corta (8 mínimo). ";}
			if(error.data.errors.password_confirmation) {err += "Las contraseñas no coinciden. ";}
			$rootScope.addAlert({
				type: 'danger',
				msg: err
			}, true);
			usSpinnerService.stop('spinner');
		});
	}
}]);