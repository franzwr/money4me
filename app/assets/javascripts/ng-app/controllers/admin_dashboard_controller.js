angular.module('money4me.controllers')

/*  Performs all admin dashboard related tasks. */
.controller('AdminDashboardCtrl', ['$scope', '$rootScope', 'Auth', '$location', '$modal', '$http', 'usSpinnerService',
	function ($scope, $rootScope, Auth, $location, $modal, $http, usSpinnerService) {
	
	Auth.currentUser().then( function (user) {
		if(user["type"] != "Admin") {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Debe identificarse como administrador para ingresar a esta página.'
			});
			Auth.logout();
			$location.path('/');
		}
	} , function () {
		$rootScope.addAlert({
			type: 'danger',
			msg: 'Debe identificarse como administrador para ingresar a esta página.'
		});
		Auth.logout();
		$location.path('/');
	});

	$scope.filteredCompanies = $rootScope.currentUser.companies;
	$scope.userRequests = $rootScope.currentUser.users;
	$scope.currentPage = 0;
	$scope.pageSize = 10;
	$scope.lastPage = Math.ceil($scope.filteredCompanies.length/$scope.pageSize) - 1;
	
	/** Calculates the last page in the company tab. */
	$scope.getLastPage = function (iterable) {
		var out = Math.ceil(iterable.length/$scope.lastPage) - 1;
		$scope.lastPage = out;
		return out;
	};

	/** Shows the details modal for companies forms. */
	$scope.details = function (company) {
		var modalInstance = $modal.open({
			templateUrl: 'detailsModal.html',
			controller: 'DetailsModalCtrl',
			size: 'sm',
			resolve: {
				company: function () {
					return company;
				}
			}
		});
	};

	/** Activates the company and sends the user an email with login info. */
	$scope.activate = function (company) {
		usSpinnerService.spin('spinner');
		var url = "http://localhost:3000/api/empresa/";
		var data = {
			empresa: {
				nombre: company.nombre,
				cuenta_banco: company.cuenta_banco,
				activa: true,
				rut_empresa: company.rut_empresa
			}
		};

		$http.put(url + company.id_empresa.toString(), angular.toJson(data))
			.success(function (data, status) {
				usSpinnerService.stop('spinner');
				company.activa = true;
				$scope.filteredCompanies = $rootScope.currentUser.companies;
				$rootScope.addAlert({
					type: 'success',
					msg: 'Se ha enviado un correo al usuario notificando la activación.'
				});
			})
			.error(function (data, status) {
				usSpinnerService.stop('spinner');
				$rootScope.addAlert({
					type: 'danger',
					msg: 'Ha ocurrido un error. Intente más tarde.'
				});
			});
	};

	/** Sends the notification email to the user with the reset token, validating the request. */
	$scope.validateUserRequest = function (user) {
		usSpinnerService.spin('spinner1');
		var url = "http://localhost:3000/validate_password_reset/";
		$http.get(url + user.id.toString())
			.success(function (data, status) {
				usSpinnerService.stop('spinner1');
				$scope.userRequests = data;
				$rootScope.addAlert({
					type: 'success',
					msg: 'La petición fue validada. Se envió un correo notificando al usuario.'
				});
			})
			.error(function (data, status) {
				usSpinnerService.stop('spinner1');
				$rootScope.addAlert({
					type: 'danger',
					msg: 'La petición no puede ser validada en este momento. Intente más tarde.'
				});
			});
	};

}])

/** Details Modal controller. */
.controller('DetailsModalCtrl', ['$modalInstance', 'company', '$scope', function ($modalInstance, company, $scope) {
	$scope.company = company;

	$scope.close = function () {
		$modalInstance.close(false);
	};
}])

/** Custom filter for pagination system. Expects an integer param, and returns the data iterable sliced at the param. */
.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});