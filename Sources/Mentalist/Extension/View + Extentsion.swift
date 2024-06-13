//
//  View + Extentsion.swift
//
//
//  Created by Enebin on 6/12/24.
//

import SwiftUI

extension View {
    func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}
