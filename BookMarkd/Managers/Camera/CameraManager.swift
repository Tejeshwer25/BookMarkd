//
//  CameraManager.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 20/04/26.
//

import UIKit
import Vision
@preconcurrency import AVFoundation
import Combine

final class CameraManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    
    @Published var capturedImage: UIImage?
    
    override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        session.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back), let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        Task.detached(priority: .userInitiated) {
            await self.session.startRunning()
        }
    }
    
    func stopSession() {
        Task.detached(priority: .userInitiated) {
            await self.session.stopRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func handleCapturedImage(_ image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "AddBookHeaderSection", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get CGImage from captured UIImage."])
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        var fullText = ""
        
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                return
            }
            
            if let observations = request.results as? [VNRecognizedTextObservation] {
                for observation in observations {
                    if let topCandidate = observation.topCandidates(1).first {
                        fullText += topCandidate.string + "\n"
                    }
                }
            }
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        request.usesLanguageCorrection = true
        try requestHandler.perform([request])
        
        return fullText
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            return
        }
        
        Task { @MainActor in
            self.capturedImage = image
        }
    }
}
