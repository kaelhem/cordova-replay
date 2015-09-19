cordova-replay
======

Install
-------
```
cordova plugin add cordova-replay
```

Description
-----------

This cordova plugin allows to use the ReplayKit framework in iOS.
The ReplayKit is a new feature in iOS 9.0, that performs screen / microphone recording.


The plugin is referenced by `cordova.plugins.Replay`.


Methods
-------
**- startRecording(isMicrophoneEnabled, successCallback, errorCallback)**

* isMicrophoneEnabled [*Bool*]: does the microphone is enabled
* successCallback [*Function*]: callback triggered when succeed
* errorCallback [*Function*]: callback triggered when failed

**- stopRecording(successCallback, errorCallback)**

* successCallback [*Function*]: callback triggered when succeed
* errorCallback [*Function*]: callback triggered when failed


Usage sample
------------

```
// start a screen+mic record, and stop it 5sec later

var isRecording = false;
function startRecord(enableMic) {
	cordova.plugins.Replay.startRecording(enableMic,
		function() {
   	 		isRecording = true;
   	 	}, function(err) {
    		console.log(err);
	    }
	);
};
function stopRecording = function() {
    cordova.plugins.Replay.stopRecording(
       	function() {
       		isRecording = false;
          	console.log('ok!');
        }, function(err) {
      		console.log(err);
        }
	);
}
startRecording(true);
setTimeout(function() {
	stopRecording();	
}, 5000)
```


Supported Platforms
-------------------

- iOS


Troubleshouting
---------------

* be sure to target iOS 9.0 minimum
* in case of error :
```
dyld: Library not loaded: @rpath/libswiftCore.dylib
```
maybe to will need to add `@executable_path/Frameworks` in the *Build Settings > Runpath Search Paths* of your xcode project.