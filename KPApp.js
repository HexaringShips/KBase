"use strict";
var itemApp = angular.module("itemApp",
    [

    ]);



itemApp.service('ajaxService', ['$http', function ($http) {
    this.AjaxPost = function (data, route, successFunction, errorFunction) {


        $http.post(route, data).success(function
                          (response, status, headers, config) {

            successFunction(response, status);
        }).error(function (response) {


            errorFunction(response);
        });

    }


    this.AjaxGet = function (route, successFunction, errorFunction) {


        $http({ method: 'GET', url: route }).success(
            function (response, status, headers, config) {

                successFunction(response, status);
            }).error(function (response) {


                errorFunction(response);
            });

    }

}])

itemApp.service('dataService', ['ajaxService', function (ajaxService) {

    this.getdata = ajaxService.AjaxGet(data, route, successfunction, errorfunction);

    this.postData = ajaxService.AjaxPost(data, route, successfunction, errorfunction);

}])

itemApp.controller("incidentController", ["$scope", "dataService", function ($scope, dataService) {
    $scope.data = [];

    var request = {
        searchText :""
    }
    var url = "api/itemAPI";

    dataService.getdata(request, url, loadSuccess, errorFunction)

    $scope.loadSuccess = function (response) {
        $scope.data = response.data;
    }

    $scope.errorFunction = function (response) {

    }

    var item = {
        id: 1,
        name: "engine abhi",
        description: "Engine stuck in the middle of working",
        date: "2/1/2017",
        status: "resolved",
        imagePath: "Content/Images/largest-gas-turbine-engine.jpg"
    }

    $scope.data.push(item);
    var item2 = {
        id: 1,
        name: "engine gopi",
        description: "Engine stuck in the middle of working",
        date: "2/1/2017",
        status: "New",
        imagePath: "Content/Images/largest-gas-turbine-engine.jpg"
    }
    $scope.data.push(item2);
    var item3 = {
        id: 1,
        name: "engine kishore",
        description: "Engine stuck in the middle of working",
        date: "2/1/2017",
        status: "InProgress",
        imagePath: "Content/Images/largest-gas-turbine-engine.jpg"
    }
    $scope.data.push(item3);
    var item4 = {
        id: 1,
        name: "engine manoj",
        description: "Engine stuck in the middle of working",
        date: "2/1/2017",
        status: "New",
        imagePath: "Content/Images/largest-gas-turbine-engine.jpg"
    }

    $scope.data.push(item4);

    $scope.enableAdd = function () {
        $scope.enableAddNew = true;
    }
    $scope.item = {};
    $scope.statusList = ['New', 'Closed', 'InProgress'];

    $scope.addNew = function () {
        $scope.data.push($scope.item);
        $scope.enableAddNew = false;
    }

}])


itemApp.directive("itemAdd", function ($scope) {
    $scope.item = [];
    var request = {
        item: $scope.item;
    }
    var url = "api/itemAPI";

    dataService.postData(request, url, loadSuccess, errorFunction)

    $scope.loadSuccess = function (response) {
        $scope.data = response.data;
    }

    $scope.errorFunction = function (response) {

    }

})

itemApp.directive("itemEdit", function ($scope) {

})


