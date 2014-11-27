angular.module('money4me.controllers')

// Main controller for the Sign Up view
.controller('EmpresaSignUpCtrl', ['$scope', '$location', '$rootScope', 'Auth', 'usSpinnerService',
 function ($scope, $location, $rootScope, Auth, usSpinnerService) {
 	// User object
	$scope.user = {
		type: 'Client'
	};
	
	// Users the Auth module to register the user through Devise.
	$scope.empresa_sign_up = function(user) {
		usSpinnerService.spin('spinner');
		// HTTP request
		Auth.register(user).then(function(response) {
			// Successfull sign up
			$rootScope.addAlert({
				type: 'success',
				msg: "El formulario ha sido enviado con éxito.",
			});
			usSpinnerService.stop('spinner');
			// Redirects to home
			$location.path('/'); 
		}, function(error) {
			// Unsuccessfull sign up. Shows all errors throwed by the server.
			$rootScope.addAlert({
				type: 'danger',
				msg: "No se logró completar el registro.",
			}, true);
			usSpinnerService.stop('spinner');
		});
	};
}]);
