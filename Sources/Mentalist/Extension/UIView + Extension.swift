//
//  UIView + Extension.swift
//
//
//  Created by Enebin on 6/12/24.
//

import UIKit

extension UIView {
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
