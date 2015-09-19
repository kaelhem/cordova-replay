var exec = require('cordova/exec');

var Replay = function() {};

Replay.startRecording = function(isMicrophoneEnabled, success, error) {
    exec(success, error, "CordovaReplay", "startRecording", [isMicrophoneEnabled]);
};

Replay.stopRecording = function(success, error) {
    exec(success, error, "CordovaReplay", "stopRecording");
};

module.exports = Replay;