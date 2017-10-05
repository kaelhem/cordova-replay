import ReplayKit
import UIKit

@objc(CordovaReplay) class CordovaReplay : CDVPlugin, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {

  weak var previewViewController: RPPreviewViewController?
  var CDVWebview:UIWebView;

  // This is just called if <param name="onload" value="true" /> in plugin.xml.
    init(webView: UIWebView) {
        NSLog("CordovaReplay#init()")
        self.CDVWebview = webView
//        super.init(webView: webView)
    }

  func startRecording(_ command: CDVInvokedUrlCommand) {
    let recorder = RPScreenRecorder.shared()
    recorder.delegate = self
//    let isMicrophoneEnabled = command.argument(at: 0) as! Bool
    if #available(iOS 10.0, *) {
        recorder.startRecording() { [unowned self] (error) in
            var pluginResult:CDVPluginResult
            if let unwrappedError = error {
                pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: unwrappedError.localizedDescription)
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            } else {
                pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            }
        }
    } else {
        // ???
        // recorder.startRecording not defined iOS <10.0
        var pluginResult:CDVPluginResult
        pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR)
        pluginResult.setKeepCallbackAs(true)
        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
    }
  }

  func stopRecording(_ command: CDVInvokedUrlCommand) {
    let recorder = RPScreenRecorder.shared()

    recorder.stopRecording { [unowned self] (preview, error) in
      var pluginResult:CDVPluginResult
      if let unwrappedPreview = preview {
        unwrappedPreview.previewControllerDelegate = self
        self.previewViewController = unwrappedPreview
        self.previewViewController!.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.viewController.present(unwrappedPreview, animated: true, completion: nil);
        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        pluginResult.setKeepCallbackAs(true)
        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
      }
      if let unwrappedError = error {
        pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: unwrappedError.localizedDescription)
        pluginResult.setKeepCallbackAs(true)
        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
      }
    }
  }

  func previewControllerDidFinish(previewController: RPPreviewViewController) {
    previewController.dismiss(animated: true, completion: nil)
  }

  override func onReset() {
    NSLog("CordovaReplay#onReset() | doing nothing")
  }

  override func onAppTerminate() {
    NSLog("CordovaReplay#onAppTerminate() | doing nothing")
  }
}
