import ReplayKit
import UIKit

@objc(CordovaReplay) class CordovaReplay : CDVPlugin, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {

  weak var previewViewController: RPPreviewViewController?
  var CDVWebview:UIWebView;

	// This is just called if <param name="onload" value="true" /> in plugin.xml.
	override init(webView: UIWebView) {
		NSLog("CordovaReplay#init()")
		self.CDVWebview = webView
		super.init(webView: webView)
	}

  func startRecording(command: CDVInvokedUrlCommand) {
    let recorder = RPScreenRecorder.sharedRecorder()
    recorder.delegate = self
    let isMicrophoneEnabled = command.argumentAtIndex(0) as! Bool
    recorder.startRecordingWithMicrophoneEnabled(isMicrophoneEnabled) { [unowned self] (error) in
      var pluginResult:CDVPluginResult
      if let unwrappedError = error {
        pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAsString: unwrappedError.localizedDescription)
        pluginResult.setKeepCallbackAsBool(true)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
      } else {
        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        pluginResult.setKeepCallbackAsBool(true)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
      }
    }
  }

  func stopRecording(command: CDVInvokedUrlCommand) {
    let recorder = RPScreenRecorder.sharedRecorder()

    recorder.stopRecordingWithHandler { [unowned self] (preview, error) in
      var pluginResult:CDVPluginResult
      if let unwrappedPreview = preview {
        unwrappedPreview.previewControllerDelegate = self
        self.previewViewController = unwrappedPreview
        self.previewViewController!.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
        self.CDVWebview.window!.rootViewController!.presentViewController(unwrappedPreview, animated: true, completion: nil)
        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        pluginResult.setKeepCallbackAsBool(true)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
      }
      if let unwrappedError = error {
        pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAsString: unwrappedError.localizedDescription)
        pluginResult.setKeepCallbackAsBool(true)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
      }
    }
  }

  func previewControllerDidFinish(previewController: RPPreviewViewController) {
    previewController.dismissViewControllerAnimated(true, completion: nil)
  }

  override func onReset() {
	NSLog("CordovaReplay#onReset() | doing nothing")
  }

  override func onAppTerminate() {
	NSLog("CordovaReplay#onAppTerminate() | doing nothing")
  }
}