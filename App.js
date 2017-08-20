var itemApp = angular.module("gridApp",
    [
        'ui.grid'
    ]);

var uploadedfilename = '';
itemApp.directive("fileread", [function () {
    return {
        scope: {
            fileread: "="
        },
        link: function (scope, element, attributes) {
            element.bind("change", function (changeEvent) {
                var reader = new FileReader();
                uploadedfilename = changeEvent.target.files[0].name;
                reader.onload = function (loadEvent) {
                    scope.$apply(function () {
                        scope.fileread = loadEvent.target.result;
                    });
                }
                reader.readAsDataURL(changeEvent.target.files[0]);
            });
        }
    }
}]);

itemApp.controller("gridController", ["$scope", "$filter", "$http", function ($scope, $filter, $http) {
    $scope.scopeName = 'grid';
    $scope.myFile = {};
    $scope.AttachmentLinkCheck = true;
    function LoadGrid() {
        $http({ 'url': 'api/Incidents', 'method': 'GET' }).then(function (response) {

            
           
           
            angular.forEach(response.data, function (data) {
                data.CreatedDate = $filter('date')(data.CreatedDate, "MM/dd/yyyy");
                switch (data.Status) {
                    case 0:
                        data.StatusName = 'New'
                        break;
                    case 1:
                        data.StatusName = 'Open'
                        break;
                    case 2:
                        data.StatusName = 'Closed'
                        break;
                }
            });
            $scope.items = $scope.gridOptions.data = response.data;
        });
    }
    var selectionCellTemplate = '<div class="ngCellText ui-grid-cell-contents">' +
               ' <div ng-click="grid.appScope.rowClick(row)">{{COL_FIELD}}</div>' +
               '</div>';

    $scope.rowClick = function (row) {
        $scope.AttachmentLinkCheck = row.entity.AttachmentPath != null;
        $scope.attachmenthttppath = 'Content/Images/' + row.entity.AttachmentPath;
        $scope.mode = 'review';
        $scope.reviewItem = row.entity;
    };

    $scope.mode = 'grid';

    $scope.gridOptions = {
        data: [],
        columnDefs: []

    }
    LoadGrid();
    $scope.gridOptions.data = $scope.items;
    $scope.columns = [];

    var gridColumn = {
        displayName: 'ID',
        field: 'Id',
        minWidth: 40,
        cellTemplate: selectionCellTemplate
    }

    $scope.columns.push(gridColumn);

    var gridColumn2 = {
        displayName: 'Title',
        field: 'Title',
        minWidth: 40
    }

    $scope.columns.push(gridColumn2);

    var gridColumn3 = {
        displayName: 'Description',
        field: 'Description',
        minWidth: 400
    }
    
    $scope.columns.push(gridColumn3);

    //if you dont want this column just remove this block
    var attachmenttemplate = '<img src="Content/Images/attach.png" ng-if="grid.appScope.hideorshow(row.entity.AttachmentPath)" width="25" height="25" alt="" />';
    var gridColumn8 = {
        displayName: '',
        field:'AttachmentPath',
        cellTemplate: attachmenttemplate,
        width: 30,
        cellClass: 'no-left-border'
    }
    $scope.columns.push(gridColumn8);
    //if you dont want this column just remove this block

    var gridColumn4 = {
        displayName: 'Date',
        field: 'CreatedDate',
        minWidth: 40
    }

    $scope.columns.push(gridColumn4);

    var gridColumn5 = {
        displayName: 'Status',
        field: 'StatusName',
        minWidth: 40
    }

    $scope.columns.push(gridColumn5);

    var gridColumn6 = {
        displayName: 'Modify',
        field: 'option',
        cellTemplate: '<a href="javascript:void(0);" ng-click="grid.appScope.editClick(row.entity)" >Edit</a>',
        minWidth: 40,
        center: true
    }

    $scope.columns.push(gridColumn6);

    var gridColumn7 = {
        field: 'UploadedFileName',
        visible: false
    }

    $scope.columns.push(gridColumn7);

    $scope.gridOptions.columnDefs = $scope.columns;
    $scope.title = 'Knowledge Management Portal';

    $scope.addNew = function () {
        $scope.mode = 'add';
        $scope.addItem = {}
    }

    $scope.Search = {};
    $scope.SearchContent = function (data) {
        $scope.filteredItems = [];
        $scope.gridOptions.data = $filter('filter')($scope.items, data);
    }
    
    $scope.Add = function () {
        $scope.mode = 'grid';
        if ($scope.addItem.file) {
            $scope.addItem.AttachmentPath = $scope.addItem.file.split(',')[$scope.addItem.file.split(',').length - 1];
            $scope.addItem.UploadedFileName = uploadedfilename;
        }

        $http({ 'url': 'api/Incidents/', 'method': 'POST', 'data': $scope.addItem }).then(function (response) {
            LoadGrid();
        });
    }

    $scope.Edit = function () {
        $scope.mode = 'grid';
        if ($scope.editItem.file)
        {
            $scope.editItem.AttachmentPath = $scope.editItem.file.split(',')[$scope.editItem.file.split(',').length - 1];
            $scope.editItem.UploadedFileName = uploadedfilename;
        }
        else {
            $scope.editItem.AttachmentPath = "";
            $scope.editItem.UploadedFileName = "";
        }

        switch ($scope.editItem.Status) {
            case 'New':
                $scope.editItem.Status = 0;
                break;
            case 'Open':
                $scope.editItem.Status = 1;
                break;
            case 'Closed':
                $scope.editItem.Status = 2;
                break;
        }
        
        $http({ 'url': 'api/Incidents/UpdateIncident', 'method': 'PUT', 'data': $scope.editItem }).then(function (response) {
            LoadGrid();
        });
    }

    $scope.Close = function () {
        $scope.mode = 'grid';
        $scope.gridOptions.data = $scope.items;
    }

    $scope.editClick = function (row) {
        $scope.AttachmentLinkCheck = row.AttachmentPath != null;
        $scope.mode = 'edit';
        $scope.editItem = row;
        $scope.editItem.UpdatedDate = $filter('date')($scope.editItem.UpdatedDate, "MM/dd/yyyy");
        $scope.attachmenthttppath = 'Content/Images/' + row.AttachmentPath;
        switch (row.Status) {
            case 0:
                $scope.editItem.Status = 'New';
                break;
            case 1:
                $scope.editItem.Status = 'Open';
                break;
            case 2:
                $scope.editItem.Status = 'Closed';
                break;
        }
    }

    $scope.MakeDefaultButton = function (keyEvent) {
        console.log(keyEvent.which);
        if(keyEvent.which===13){
            var searchword = angular.element(document.querySelector("#txtSearch")).val();
            $scope.SearchContent(searchword);
        }
    }

    $scope.hideorshow = function (value) {
        if (value !== null)
            return true;
        else
            return false;
    }
}]);