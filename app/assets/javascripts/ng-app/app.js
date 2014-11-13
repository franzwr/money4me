/**
* Main application module. Defines all dependencies, routes, global methods and variables, configurations
* and all the code neccesary to bootstrap the application.
**/
angular
    /** App dependencies. **/
    .module('money4me', [
        'ngRoute',
        'templates',
        'Devise',
        'angularSpinner',
        'money4me.controllers',
        'money4me.services',
        'money4me.directives'
    ])
    /** App global configuration. **/
    .config(['$routeProvider', '$locationProvider', 'AuthProvider', 
    function ($routeProvider, $locationProvider, AuthProvider) {

        /** Devise configuration. **/
        AuthProvider.loginMethod('POST');
        AuthProvider.loginPath('/sign_in.json');
        AuthProvider.logoutMethod('DELETE');
        AuthProvider.logoutPath('/sign_out.json');
        AuthProvider.registerMethod('POST');
        AuthProvider.registerPath('/sign_up.json');
        AuthProvider.parse(function(response) {
            return response.data;
        });
        AuthProvider.ignoreAuth(true);

        /** Routes definition. **/
        $routeProvider
        .when('/', {
            templateUrl: 'home.html',
            controller: 'HomeCtrl'
        })
        .when('/pay_bill', {
            templateUrl: 'pay_bill.html',
            controller: 'PayBillCtrl'
        })
        .when('/sign_up', {
            templateUrl: 'sign_up.html',
            controller: 'SignUpCtrl'
        })
        .when('/user_dashboard', {
            templateUrl: 'user_dashboard.html',
            controller: 'UserDashboardCtrl'
        });

        $locationProvider.html5Mode(true);
}])
    /** Runs when angular is ready. Contains global variables and methods. **/
    .run(['$rootScope', '$http', 'Auth', '$location', '$timeout', '$window', 'usSpinnerService',
        function ($rootScope, $http, Auth, $location, $timeout, $window, usSpinnerService) {
        angular.element(document).ready( function() {

            /** At start, check if a session exists. If it does, login the user automatically. **/
            if(angular.isDefined($window.localStorage['Session'])) {
                $rootScope.$apply(function () {
                    $rootScope.signedIn = true;
                    $rootScope.currentUser = angular.fromJson($window.localStorage['Session']);
                });
            } else {
                $rootScope.signedIn = false;
                $rootScope.currentUser = {};
            }
            
            /** Sign in global method. **/
            $rootScope.signIn= function(user) {
                usSpinnerService.spin('spinner0');
                var credentials = {
                    email: user.email,
                    password: user.password
                };
                Auth.login(credentials).then(function(user) {
                    $window.localStorage['Session'] = angular.toJson(user);
                    $rootScope.addAlert({
                        type: 'success',
                        msg: "Sesión iniciada. Bienvenido " + user.name + "."
                    });
                    $location.path('/user_dashboard');
                    usSpinnerService.stop('spinner0');

                }, function(error) {
                    $rootScope.addAlert({
                        type: 'danger',
                        msg: 'Email/Password inválido(s). Verifique sus datos.'
                    });
                    usSpinnerService.stop('spinner0');
                });
            };

            /** Sign out global method. **/
            $rootScope.signOut = function() {
                Auth.logout().then( function() {
                    $rootScope.addAlert({
                        type: 'success',
                        msg: 'Sesión terminada.'
                    });
                    $window.localStorage.removeItem('Session');
                    $location.path('/');
                });
            };

            /** Auth events listeners. Modifies global variables accordingly. **/
            $rootScope.$on('devise:login', function(event, currentUser) {
                $rootScope.signedIn = true;
                $rootScope.currentUser = currentUser;
            });
            $rootScope.$on('devise:logout', function(event, currentUser) {
                $rootScope.signedIn = false;
                $rootScope.currentUser = {};
            });

            /** Alert FIFO array. **/
            $rootScope.alerts = [];

            /** Global method for displaying alerts. **/
            $rootScope.addAlert = function(alert, index, persistent) {
                if($rootScope.alerts.length == 1) {
                    $rootScope.alerts.splice(0,1);
                }
                $rootScope.alerts.push({
                    type: alert.type,
                    msg: alert.msg
                });
                if(angular.isUndefined(persistent) || !persistent) {
                    $timeout(function() {
                        $rootScope.closeAlert(index);
                    }, 5000);
                }
            };

            /** Global method for hiding alerts. **/
            $rootScope.closeAlert = function(index) {
                $rootScope.alerts.splice(index, 1);
            };
        });
    }]);

/** Module definitions. All AngularJS code can be grouped in these three modules. **/
angular.module('money4me.controllers', []);

angular.module('money4me.services', []);

angular.module('money4me.directives', []);