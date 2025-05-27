//
//  QRCodeScannerView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 27.05.25.
//

import SwiftUI
import AVFoundation

// MARK: - QRCodeScannerView

struct QRCodeScannerView: View {
    @State private var scannedCode: String?
    @State private var showingCafeDetail = false
    
    @StateObject var fetcher = CafeFetcher()

    // This will hold the shopID extracted from the QR code
    @State private var detectedShopID: String?

    var body: some View {
        ZStack {
            // The actual scanner view
            ScannerViewControllerRepresentable(scannedCode: $scannedCode)

            VStack {
                Spacer()
                Text(scannedCode ?? "Scan a QR Code")
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        .onChange(of: scannedCode) { newValue in
            if let code = newValue {
                // Here, we'll parse the code to get the shopID
                // For demonstration, let's assume the QR code directly contains the shopID
                detectedShopID = code
                fetcher.fetchCafe(by: code)
                showingCafeDetail = true
            }
        }
        .sheet(isPresented: $showingCafeDetail) {
            if let scannedCafe = fetcher.specificCafe { // Use fetcher.specificCafe
                CafeDetailView(cafe: scannedCafe)
            } else {
                // Handle the case where the cafe hasn't loaded yet or wasn't found
                Text("Loading cafe details or cafe not found...")
            }
        }
    }
}

// MARK: - ScannerViewControllerRepresentable

struct ScannerViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var scannedCode: String?

    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // MARK: Coordinator

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScannerViewControllerRepresentable

        init(parent: ScannerViewControllerRepresentable) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                // Vibrate to give feedback that a code was scanned
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

                // Update the scannedCode binding
                DispatchQueue.main.async {
                    self.parent.scannedCode = stringValue
                }
            }
        }
    }
}

// MARK: - ScannerViewController (UIKit)

class ScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: AVCaptureMetadataOutputObjectsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // Specify QR code type
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from this feature. Please use the camera app.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
