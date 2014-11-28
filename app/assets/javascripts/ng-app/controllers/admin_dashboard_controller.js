angular.module('money4me.controllers')

/*  Performs all admin dashboard related tasks. */
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
	});

	$scope.filteredCompanies = $rootScope.currentUser.companies;
	
	$scope.currentPage = 0;
	$scope.pageSize = 10;
	$scope.lastPage = Math.ceil($scope.filteredCompanies.length/$scope.pageSize) - 1;
	
	$scope.getLastPage = function (iterable) {
		var out = Math.ceil(iterable.length/$scope.lastPage) - 1;
		$scope.lastPage = out;
		return out;
	};

	$scope.activate = function (company) {
		
	};

}])

/* Custom filter for pagination system. Expects an integer param, and returns the data iterable sliced at the param. */
.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});