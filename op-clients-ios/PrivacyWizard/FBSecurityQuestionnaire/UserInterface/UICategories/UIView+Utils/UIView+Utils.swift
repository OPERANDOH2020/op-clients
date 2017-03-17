//
//  UIView+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

enum UIGradientType {
    case diagonal
    case vertical
}

extension UIView {
    
    func roundedCorners(withRadius radius: CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: self.bounds,
                                     cornerRadius: radius)
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPath1.cgPath
        self.layer.mask = maskLayer1
        
    }
    
    func add(gradientWithType type: UIGradientType, fromColors colors: [CGColor]) {
        switch type {
        case .diagonal:
            addDiagonalGradient(colors: colors)
        case .vertical:
            addVerticalGradient(colors: colors)
        }
    }
    
    private func addDiagonalGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    private func addVerticalGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        layer.addSublayer(gradientLayer)
    }
}
