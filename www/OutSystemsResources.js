var exec = require('cordova/exec');

exports.getFile = function (files, success, error) {
    exec(success, error, 'OutSystemsResources', 'getFile', [files]);
};
