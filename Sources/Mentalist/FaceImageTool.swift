//
//  FaceImageTool.swift
//  Mentalist
//
//  Created by Enebin on 6/13/24.
//

import Vision
import CoreImage
import UIKit

struct FaceImageTool {
    func preprocessImage(image: CGImage) -> CGImage? {
        // Step 1: Convert to Grayscale
        guard let grayscaleImage = convertToGrayscale(image: image) else { return nil }
        
        // Step 2: Resize
        guard let resizedImage = resizeImage(image: grayscaleImage, targetSize: CGSize(width: 48, height: 48)) else { return nil }
        
        // Step 3: Normalize
        guard let normalizedImage = normalizeImage(image: resizedImage) else { return nil }
        
        return normalizedImage
    }
    
    /// Extracts faces from the given CGImage asynchronously.
    /// - Parameter cgImage: The source CGImage from which to extract faces.
    /// - Returns: An array of VNFaceObservation objects representing the detected faces.
    /// - Throws: An error if face detection fails.
    func extractFaces(from cgImage: CGImage) throws -> [VNFaceObservation] {
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        let results = request.results

        return results ?? []
    }
    
    /// Crops a face from the given image using the specified bounding box.
    /// - Parameters:
    ///   - image: The source CGImage from which to crop the face.
    ///   - boundingBox: The CGRect representing the bounding box of the face.
    /// - Returns: A CGImage representing the cropped face, or nil if cropping fails.
    func cropFace(from image: CGImage, boundingBox: CGRect) -> CGImage? {    let width = boundingBox.width * CGFloat(image.width)
        let height = boundingBox.height * CGFloat(image.height)
        let x = boundingBox.minX * CGFloat(image.width)
        let y = (1 - boundingBox.minY) * CGFloat(image.height) - height
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        // Extract the cropped CGImage from the CGImage
        guard let croppedCGImage = image.cropping(to: cropRect) else { return nil }
        
        return croppedCGImage
    }
}

private extension FaceImageTool {
    func convertToGrayscale(image: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: image)
        
        let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")
        grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputCIImage = grayscaleFilter?.outputImage else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return cgImage
    }

    func resizeImage(image: CGImage, targetSize: CGSize) -> CGImage? {
        let width = targetSize.width
        let height = targetSize.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: Int(width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return context?.makeImage()
    }

    func normalizeImage(image: CGImage) -> CGImage? {
        let width = image.width
        let height = image.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        var pixelData = [UInt8](repeating: 0, count: width * height)
        
        let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Normalize pixel data
        let normalizedPixelData = pixelData.map { Float($0) / 255.0 }
        var denormalizedPixelData = normalizedPixelData.map { UInt8($0 * 255.0) }
        
        // Create new CGImage
        let newContext = CGContext(data: &denormalizedPixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        guard let newCgImage = newContext?.makeImage() else { return nil }
        
        return newCgImage
    }
}
