angular
    .module('AngularRails', [
        'ngRoute',
        'templates',
        'Devise',
        'ng-rails-csrf'
    ]).config(function ($routeProvider, $locationProvider, AuthProvider) {
        AuthProvider.loginMethod('POST');
        AuthProvider.loginPath('/ingresar.json');
        AuthProvider.logoutMethod('DELETE');
        AuthProvider.logoutPath('/salir.json');
        AuthProvider.registerMethod('POST');
        AuthProvider.registerPath('/registrar.json');
        $routeProvider
        .when('/', {
            templateUrl: 'home.html',
            controller: 'HomeCtrl'
        });
        $locationProvider.html5Mode(true);
});