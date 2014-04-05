var app = angular.module('litterfeldtKata', []);

app.factory('anagramFactory', function($http) {
  var factory = {};
  factory.getAnagrams = function(words) {
    return $http.get('search/' + encodeURIComponent(words));
  };
  return factory;
});

app.directive('fileModel', ['$parse', function ($parse) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var model = $parse(attrs.fileModel);
      var modelSetter = model.assign;

      element.bind('change', function(){
        scope.$apply(function(){
          modelSetter(scope, element[0].files[0]);
        });
      });
    }
  };
}]);

app.service('switches',['$scope', function($scope) {
  this.reset = function() {
    $scope.searchFail= false;
    $scope.searchSuccess = false;
    $scope.dictionaryFail= false;
    $scope.dictionarySuccess = false;
  };
}]);

app.service('fileUpload', ['$http', function ($http) {
  this.uploadFileToUrl = function(file, uploadUrl, $scope){
    var startTime = new Date();
    var fd = new FormData();
    fd.append('file', file);
    $http.post(uploadUrl, fd, {
      transformRequest: angular.identity,
      headers: {'Content-Type': undefined}
    })
    .success(function(){
      console.log("sucess");
      $scope.dictionarySuccess = true;
      $scope.httpTiming = (new Date() - startTime) / 1000;
    })
    .error(function(){
      console.log("error");
      $scope.dictionaryFail= true;
      $scope.httpTiming = (new Date() - startTime) / 1000;
    });
  }
}]);

app.controller('SearchController', function($scope, anagramFactory, fileUpload) {
  $scope.searchForAnagrams = function() {
      if($scope.searchText) {
        this.resetSwitches();
        var startTime = new Date();
        anagramFactory.getAnagrams(this.searchText)
          .success(function(data) {
              $scope.searchResponse = data;
              $scope.searchSuccess = true;
              $scope.httpTiming = (new Date() - startTime) / 1000;
            })
          .error(function(data) {
              $scope.searchResponse = null;
              $scope.searchFail= true;
              $scope.httpTiming = (new Date() - startTime) / 1000;
            });
        $scope.searchText = '';
      }
  };

  $scope.getFile = function(){
    document.getElementById("upfile").click();
  };

  $scope.resetSwitches = function() {
    $scope.searchFail= false;
    $scope.searchSuccess = false;
    $scope.dictionaryFail= false;
    $scope.dictionarySuccess = false;
  };

  $scope.uploadFile = function(){
    $scope.resetSwitches();
    setTimeout(function() {
      var file = $scope.dicFile;
      console.log('file is ' + JSON.stringify(file));
      var uploadUrl = "dictionary";
      fileUpload.uploadFileToUrl(file, uploadUrl, $scope);
    }, 250);
  };
});

