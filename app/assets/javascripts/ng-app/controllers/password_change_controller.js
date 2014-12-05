angular.module('money4me.controllers')

.controller('PasswordChangeCtrl', ['$rootScope', '$scope', '$routeParams', '$http', '$location', 'usSpinnerService', 'Auth',
	function ($rootScope, $scope, $routeParams, $http, $location, usSpinnerService, Auth) {
		if(angular.isUndefined($routeParams.reset_password_token)) {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Token inválido.'
			});
			$location.path('/');
		}

		$scope.passwordChange = function (user) {
			usSpinnerService.spin('spinner1');
			var url = 'http://localhost:3000/password_reset';
			user.reset_password_token = $routeParams.reset_password_token;
			$http.post(url, angular.toJson(user))
				.success(function (data, status) {
					usSpinnerService.stop('spinner1');
					Auth.logout();
					$rootScope.addAlert({
						type: 'success',
						msg: 'Se ha cambiado la contraseña de forma exitosa. Inicie sesión con sus nuevas credenciales.'
					}, true);
				})
				.error(function (data, status) {
					usSpinnerService.stop('spinner1');
					$rootScope.addAlert({
						type: 'danger',
						msg: 'Ha ocurrido un error. Revise que el RUT sea correcto y las contraseñas coincidan.'
					});
				});
		};
}]);