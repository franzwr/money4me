angular.module('money4me.controllers')

.controller('AdminDashboardCtrl', ['$scope', '$rootScope', function ($scope, $rootScope) {
	
	Auth.currentUser().then( function (user) {
		if(user.type != "Admin") {
			$rootScope.addAlert({
				type: 'danger',
				msg: 'Debe identificarse como administrador para ingresar a esta página.'
			});
			$location.path('/');
		}
	} , function () {
		$rootScope.addAlert({
				type: 'danger',
				msg: 'Debe identificarse como administrador para ingresar a esta página.'
			});
			$location.path('/')
	});
	
}]);