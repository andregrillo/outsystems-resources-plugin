var exec = require('cordova/exec');

exports.getFile = function (file, success, error) {
    exec(success, error, 'OutSystemsResources', 'getFile', [file]);
};
