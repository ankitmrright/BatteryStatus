var exec = require('cordova/exec');

module.exports.getLevel = function (arg0, success, error) {
    exec(success, error, 'BatteryStatus', 'getStatus', [arg0]);
};
module.exports.isPlugged = function (arg0, success, error) {
    exec(success, error, 'BatteryStatus', 'getStatus', [arg0]);
};
