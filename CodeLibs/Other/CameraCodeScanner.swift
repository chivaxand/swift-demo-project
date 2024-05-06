import AVFoundation
import UIKit

protocol CameraCodeScannerDelegate: AnyObject {
    func didCaptureCode(_ code: String)
}

class CameraCodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: CameraCodeScannerDelegate?
    private var captureDevice: AVCaptureDevice?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var codeTypes: [AVMetadataObject.ObjectType] = [.qr, .code128, .code39, .code39Mod43, .code93, .ean8, .ean13, .pdf417, .aztec, .interleaved2of5, .itf14, .upce]
    
    private static func captureDevice(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        return discoverySession.devices.first { $0.position == position }
    }
    
    func startScanning() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        self.captureDevice = captureDevice
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let captureSession = AVCaptureSession()
            self.captureSession = captureSession
            captureSession.addInput(input)
            
            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.codeTypes
            
            // Set the desired frame rate
            if let videoOutput = captureSession.outputs.first as? AVCaptureVideoDataOutput {
                do {
                    try captureDevice.lockForConfiguration()
                    captureDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 10) // 10 fps
                    captureDevice.unlockForConfiguration()
                } catch { }
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = .init(x: 0, y: 0, width: 100, height: 100)
            captureSession.startRunning()
            
        } catch {
            print("Error configuring capture device: \(error.localizedDescription)")
        }
    }
    
    func addToView(_ view: UIView) {
        guard let previewLayer = self.previewLayer else { return }
        view.layer.bounds = view.bounds
        view.layer.addSublayer(previewLayer)
        
        if let connection = previewLayer.connection,
           connection.isVideoOrientationSupported,
           let scene = view.window?.windowScene
        {
            connection.videoOrientation = videoOrientation(from: scene.interfaceOrientation) ?? .portrait
        }
    }
    
    func stopScanning() {
        self.captureSession?.stopRunning()
        self.captureSession = nil
        self.previewLayer?.removeFromSuperlayer()
        self.previewLayer = nil
    }
    
    func switchCamera() {
        guard let captureSession = self.captureSession,
              let cameraInput = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return
        }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        let currentDevice = cameraInput.device
        let newCameraPosition: AVCaptureDevice.Position = currentDevice.position == .back ? .front : .back
        
        guard let newCamera = CameraCodeScanner.captureDevice(for: newCameraPosition) else {
            return
        }
        
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newCamera) else {
            return
        }
        
        captureSession.removeInput(cameraInput)
        captureSession.addInput(newVideoInput)
    }
    
    var torchEnabled: Bool {
        get {
            guard let device = AVCaptureDevice.default(for: .video) else { return false }
            return device.isTorchActive
        }
        set {
            guard let device = AVCaptureDevice.default(for: .video) else { return }
            guard device.isTorchAvailable else { return }
            do {
                try device.lockForConfiguration()
                if newValue {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
    var torchSupported: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.hasTorch
    }
    
    func setCodeTypes(_ types: [AVMetadataObject.ObjectType]) {
        codeTypes = types
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        if let code = metadataObject.stringValue {
            delegate?.didCaptureCode(code)
        }
    }
    
    private func videoOrientation(from orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation? {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return nil
        }
    }
}
