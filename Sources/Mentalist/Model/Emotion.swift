//
//  Emotion.swift
//
//
//  Created by Enebin on 6/12/24.
//

import Foundation

public enum Emotion: String, CaseIterable {
    case angry, disgust, fear, happy, sad, surprise, neutral
    
    var name: String {
        rawValue
    }
}

extension [Emotion: Double] {
    /// Return nil when no emtion is domin±ed
    var dominantEmotion: Emotion? {
        self.max { a, b in a.value < b.value }?.key
    }
}
