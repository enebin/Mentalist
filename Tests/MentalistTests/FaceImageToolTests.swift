//
//  FaceImageToolTests.swift
//
//
//  Created by Enebin on 6/13/24.
//

import Foundation
import Vision
import XCTest

@testable import Mentalist

final class FaceImageToolTests: XCTestCase {
    var faceImageTool: FaceImageTool!
    
    override func setUp() {
        super.setUp()
        faceImageTool = FaceImageTool()
    }
    
    override func tearDown() {
        faceImageTool = nil
        super.tearDown()
    }
    
    func testPreprocessImage() throws {
        // Given
        let cgImage = try loadTestImage(named: "happy")
        
        // When
        let preprocessedImage = faceImageTool.preprocessImage(image: cgImage)
        
        // Then
        XCTAssertNotNil(preprocessedImage)
    }
    
    func testExtractFaces() throws {
        // Given
        let cgImage = try loadTestImage(named: "happy")

        // When
        let faces = try faceImageTool.extractFaces(from: cgImage)
        
        // Then
        XCTAssertNotNil(faces)
        XCTAssertEqual(faces.count, 1)
    }
    
    func testExtractMultipleFaces() throws {
        // Given
        let cgImage = try loadTestImage(named: "multiple_faces")

        // When
        let faces = try faceImageTool.extractFaces(from: cgImage)
        
        // Then
        XCTAssertNotNil(faces)
        XCTAssertEqual(faces.count, 5)
    }

    func testCropFace() throws {
        // Given
        let cgImage = try loadTestImage(named: "happy")
        let boundingBox = CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4)
        
        // When
        let croppedFace = faceImageTool.cropFace(from: cgImage, boundingBox: boundingBox)
        
        // Then
        XCTAssertNotNil(croppedFace)
    }
}

extension FaceImageToolTests {
    // Helper method to load test images
    private func loadTestImage(named name: String) throws -> CGImage {
        let uiImage = UIImage(named: name, in: .module, with: nil)
        return try XCTUnwrap(uiImage?.cgImage)
    }
}
