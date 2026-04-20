//
//  CameraManager.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 20/04/26.
//

import UIKit
import Vision

actor CameraManager {
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
