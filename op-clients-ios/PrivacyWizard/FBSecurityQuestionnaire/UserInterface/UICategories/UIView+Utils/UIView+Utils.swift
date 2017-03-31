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
    
    
    func addSubview(withBackgroundColor bgColor: UIColor, alpha: CGFloat, cropRectFrom start: CGPoint, width: CGFloat, height: CGFloat) {
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(rect: self.bounds)
        path.move(to: start)
        path.addLine(to: CGPoint(x: start.x + width, y: start.y ))
        path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
        path.addLine(to: CGPoint(x: start.x, y: start.y + height))
        path.close()
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        overlay.layer.mask = maskLayer
        overlay.clipsToBounds = true
        
        overlay.alpha = alpha
        overlay.backgroundColor = bgColor
        
        addSubview(overlay)
    }
    
    // MARK: - Shapes
    func roundedCorners(withRadius radius: CGFloat){
        let maskPath1 = UIBezierPath(roundedRect: self.bounds,
                                     cornerRadius: radius)
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPath1.cgPath
        self.layer.mask = maskLayer1
        
    }
    
    // MARK: - Gradients
    func add(gradientWithType type: UIGradientType, fromColors colors: [CGColor]) {
        switch type {
        case .diagonal:
            addDiagonalGradient(colors: colors)
        case .vertical:
            addVerticalGradient(colors: colors)
        }
    }
    
    func addRadialGradient(fromColors colors: [CGColor], gradientCenter: CGPoint, radius: CGFloat) {
        let colors = colors as CFArray
        
        if let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil) {
            
            UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient, startCenter: gradientCenter, startRadius: 0.0, endCenter: gradientCenter, endRadius: radius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
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
