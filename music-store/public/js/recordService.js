'use strict';

var Record = musicStore.factory('Record', function ($resource) {
    return $resource('/record/:recordId', {}, {
        query: { method: 'GET', params: { recordId: 'recordId' }, isArray: false }
    })
});
