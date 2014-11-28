angular.module('money4me.controllers')

.controller('AdminDashboardCtrl', ['$scope', '$rootScope', 'Auth', '$location', 
	function ($scope, $rootScope, Auth, $location) {
	
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
	});0
	
}]);