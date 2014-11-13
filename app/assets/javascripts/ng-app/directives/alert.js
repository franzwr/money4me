angular.module('money4me.directives')

/** Controller designed to hold all scope variables of the directive and its close functionality. **/
.controller('AlertController', ['$scope', '$attrs', function ($scope, $attrs) {
  $scope.closeable = 'close' in $attrs;
}])

/** Alert Directive. Wraps Bootstrap 3 Alert template and javascript. **/
.directive('alert', function () {
  return {
    restrict:'EA',
    controller:'AlertController',
    templateUrl:'bootstrap/alert.html',
    transclude:true,
    replace:true,
    scope: {
      type: '@',
      close: '&'
    }
  };
});