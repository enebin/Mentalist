//
//  MentalistCore.swift
//
//
//  Created by enebin on 6/12/24.
//

import Vision

class MentalistCore {
    private let faceImageTool: FaceImageTool
    private var mlModel: VNCoreMLModel?

    init(_ faceImageTool: FaceImageTool = .init()) {
        self.faceImageTool = faceImageTool
    }
    
    func analyze(cgImage: CGImage) throws -> [EmotionAnalysis] {
        guard let mlModel else {
            self.mlModel = try makeMLModel()
            return try analyze(cgImage: cgImage)
        }
        
        let faces = try faceImageTool.extractFaces(from: cgImage)
        
        return try faces.compactMap { (face) -> EmotionAnalysis? in
            let boundingBox = face.boundingBox
            guard let faceImage = faceImageTool.cropFace(from: cgImage, boundingBox: boundingBox) else {
                return nil
            }
            
            guard let preprocessedFaceImage = faceImageTool.preprocessImage(image: faceImage) else {
                return nil
            }
            
            let request = VNCoreMLRequest(model: mlModel)
            let handler = VNImageRequestHandler(cgImage: preprocessedFaceImage)
            try handler.perform([request])
            
            guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
                  let firstObservation = observations.first,
                  let multiArray = firstObservation.featureValue.multiArrayValue 
            else {
                return nil
            }
            
            let emotionResult: [Emotion: Double] = Emotion.allCases.enumerated().reduce(into: [:]) { result, pair in
                let (index, emotionLabel) = pair
                let emotionPrediction = Double(truncating: multiArray[index]) * 100.0
                
                result[emotionLabel] = emotionPrediction
            }
            
            let dominantEmotion = emotionResult.dominantEmotion ?? .neutral
            return EmotionAnalysis(region: boundingBox, emotion: emotionResult, dominantEmotion: dominantEmotion)
        }
    }
}

extension MentalistCore {
    private func makeMLModel() throws -> VNCoreMLModel {
        let configuration = MLModelConfiguration()
        let classifier = try FacialExpressionModel(configuration: configuration)
        
        return try VNCoreMLModel(for: classifier.model)
    }
}
