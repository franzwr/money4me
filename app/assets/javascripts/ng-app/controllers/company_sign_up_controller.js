angular.module('money4me.controllers')

/* Main controller for the Company Sign Up view */
.controller('CompanySignUpCtrl', ['$scope', '$location', '$rootScope', 'Auth', 'usSpinnerService', '$http',
 function ($scope, $location, $rootScope, Auth, usSpinnerService, $http) {
 	
 	/* Creates a company, then registers the company user */
 	$scope.signUpCompany = function (company, company_user) {
 		usSpinnerService.spin('spinner');
 		company.activa = false;
 		company_user["type"] = 'CompanyUser';

 		$http.post('http://localhost:3000/api/empresa', company)
 			.success(function (data, status) {
 				if(status == 200) {
 					company_user.id_empresa = data.id_empresa;
 					Auth.register($scope.company_user)
 						.then(function (user) {
 							usSpinnerService.stop('spinner');
 							$rootScope.addAlert({
 								type: 'success',
 								msg: 'Se ha enviado el formulario. Recibirá un correo con las pasos a seguir.'
 							});
 						}, function (error) {
 							usSpinnerService.stop('spinner');
 							var err = "No se logró completar el registro. ";
							if(error.data.errors.email) {err += "El email se encuentra en uso. ";}
							if(error.data.errors.rut) {err += "El RUT de Administrador se encuentra en uso. ";}
 							$rootScope.addAlert({
 								type: 'danger',
 								msg: err
 							}, true);
 						});
 				} else {
 					usSpinnerService.stop('spinner');
 					$rootScope.addAlert({
 						type: 'danger',
 						msg: 'No fue posible enviar el formulario. Revise los datos ingresados o intente más tarde.'
 					});
 				}
 			})
 			.error(function (data, status) {
 				usSpinnerService.stop('spinner');
 				$rootScope.addAlert({
 					type: 'danger',
 					msg: 'No fue posible enviar el formulario. Revise los datos ingresados o intente más tarde.'
 				});
 			});
 	}
	
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
