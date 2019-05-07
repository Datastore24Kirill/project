//
//  QRCodeViewController.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/25/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeViewControllerOutput: class {
    func presentPreviousVC()
    func registrationWithQR(code: String)
}

protocol QRCodeViewControllerInput: class {
    func showAlertError(with title: String?, message: String?)
    func qrCodeViewHideSpinner()
}

class QRCodeViewController: VerifierAppDefaultViewController {

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoCaptureView: UIView!
    @IBOutlet private weak var scanButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var captureMetadataOutput: AVCaptureMetadataOutput?
    
    var presenter: QRCodeViewControllerOutput!
    
    
    //MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        QRCodeAssembly.sharedInstance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = UIColor.verifierLoginBackgroundColor()
        scanButton.setTitle("Scan".localized(), for: .normal)
        scanButton.backgroundColor = UIColor.verifierDarkColor()
        scanButton.layer.cornerRadius = 5
        backButton.setTitle("Back".localized().uppercased(), for: .normal)
        backButton.backgroundColor = UIColor.verifierDarkBlueColor()
        
        
        infoLabel.attributedText = getsignUpInfoAttributedText()
        infoLabel.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkAccessToCamera()
    }
    
    
    //MARK: private
    
    private func getsignUpInfoAttributedText() -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let signUpInfoAttributedText = NSMutableAttributedString(
            string: "QR enter".localized(),
            attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.white,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.paragraphStyle : paragraphStyle
            ]
        )
        return signUpInfoAttributedText
    }
    
    private func checkAccessToCamera() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(
            for: AVMediaType.video
        )
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccess(
                for: AVMediaType.video,
                completionHandler: { granted -> Void in
                    DispatchQueue.main.async {
                        if granted {
                            self.setupScanner()
                        } else {
                            self.showAccessCameraAlert()
                        }
                    }
            })
        case .authorized:
            setupScanner()
        case .denied, .restricted:
            showAccessCameraAlert()
        }
    }
    
    private func setupScanner() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType(rawValue: AVMediaType.video.rawValue)) else {
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput!)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput?.setMetadataObjectsDelegate(
                self,
                queue: DispatchQueue.main
            )
            captureMetadataOutput?.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = videoView.layer.bounds
            videoView.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            if let scanRect = videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: videoCaptureView!.bounds) {
                captureMetadataOutput?.rectOfInterest = scanRect
                print("scanRect = \(scanRect)")
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    @objc private func openSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
    
    private func showAccessCameraAlert() {
        showAlertError(with: "", message: "")
    }
    
    @objc private func relaunchScanner() {
        captureSession?.startRunning()
    }
    
    
    //MARK: - actions
    
    @IBAction func scanButtonAction(_ sender: Any) {
       checkAccessToCamera()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        presenter.presentPreviousVC()
    }
}

extension QRCodeViewController: QRCodeViewControllerInput {
    func showAlertError(with title: String?, message: String?) {
        let actionOk = UIAlertAction(title: "OK".localized(), style: .default) { [weak self] _ in
            self?.relaunchScanner()
        }
        showAlert(title: title ?? "", message: message ?? "", action: actionOk)
    }
    
    func qrCodeViewHideSpinner() {
        hideSpinner()
    }
}

extension QRCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            print("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let stringValue = metadataObj.stringValue {
                print("QR Code = " + stringValue)
                handleQRCodeValue(value: stringValue)
                captureSession?.stopRunning()
            }
        }
    }
    
    private func handleQRCodeValue(value: String) {
        showSpinner()
        presenter.registrationWithQR(code: value)
    }
}
