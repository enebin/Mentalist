import Foundation
import SwiftUI
import Vision

@available(iOS 15.0, *)
public struct Mentalist {
    static private let core = MentalistCore()

    public static func analyze(cgImage: CGImage) throws -> [EmotionAnalysis] {
        return try core.analyze(cgImage: cgImage)
    }
    
    public static func analyze(uiImage: UIImage) throws -> [EmotionAnalysis] {
        guard let cgImage = uiImage.cgImage else {
            throw NSError(domain: "UIImage to CGImage conversion failed", code: 0)
        }
       
        return try analyze(cgImage: cgImage)
    }
    
    public static func analyze(image: Image) throws -> [EmotionAnalysis] {
        guard let cgImage = image.asUIImage().cgImage else {
            throw NSError(domain: "Image to CGImage conversion failed", code: 0)
        }
        
        return try analyze(cgImage: cgImage)
    }
}
