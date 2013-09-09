'use strict';

var musicStore = angular.module('musicStore', ['ngResource']).
    config(function($routeProvider) {
        //$locationProvider.html5Mode(true);
        $routeProvider.
            when('/records', { 
                 templateUrl: 'partials/record-list.html', 
                 controller: 'RecordListCtrl'}
                ).
            when('/record/:recordId/edit', {
                templateUrl: 'partials/record-edit.html',
                controller: 'RecordEditCtrl'}
                ).
            when('/record/add', {
                 templateUrl: 'partials/record-save.html',
                 controller: 'RecordAddCtrl'}
                 ).
            otherwise({redirectTo: '/records'});
});
            
musicStore.factory('Record', function($resource) {
    return $resource(
        '/record/:recordId', 
        {},
        { 
            get:    { method: 'GET', isArray: false },
            query:  { method: 'GET', isArray: true },
            save:   { method: 'POST' },
            update: { method: 'PUT' },
            remove: { method: 'DELETE' }
        }
    );
});

var RecordListCtrl = function(Record, $scope, $routeParams) {
    $scope.records = Record.query();
};

var RecordEditCtrl = function( Record, $scope, $routeParams, $location) {
    $scope.record = Record.get({recordId: $routeParams.recordId});
    $scope.updateRecord = function() {
        var record = this.record;
        Record.update({recordId: record.id}, record);
        $location.path('/');
    }

    $scope.removeRecord = function() {
        var record = this.record;
        Record.remove({recordId: record.id});
        $location.path('/');
    }
};

var RecordAddCtrl = function( Record, $scope, $routeParams, $location) {
    $scope.record = new Record();
    $scope.addRecord = function() {
        var record = this.record;
        Record.save(record);
        $location.path('/');
    }
};
