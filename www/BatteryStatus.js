var exec = require('cordova/exec');

module.exports.getStatus = function (arg0, success, error) {
    exec(success, error, 'BatteryStatus', 'getStatus', [arg0]);
};
