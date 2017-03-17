//
//  UIColor+Utilities.swift
//  Operando
//
//  Created by Costin Andronache on 10/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

extension UIColor{
    
    private static let maxHex: Float = 255
    
    private static func customColor(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/maxHex, green: green/maxHex, blue: blue/maxHex, alpha: 1.0)
    }
    
    private static func customColor(red: Float, green: Float, blue: Float, alpha: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/maxHex, green: green/maxHex, blue: blue/maxHex, alpha: alpha)
    }
    
    static var operandoDarkBlue: UIColor {
        return customColor(red: 44, green: 99, blue: 210)
    }
    
    static var operandoBlue: UIColor {
        return customColor(red: 35, green: 147, blue: 184)
    }
    
    static var operandoMidBlue: UIColor {
        return customColor(red: 36, green: 95, blue: 185)
    }
    
    static var operandoLightBlue: UIColor {
        return customColor(red: 56, green: 115, blue: 205)
    }
    
    static var operandoGreen: UIColor {
        return customColor(red: 9, green: 112, blue: 84)
    }
    
    static var operandoSkyBlue: UIColor {
        return customColor(red: 16, green: 75, blue: 165)
    }
    
    static var operandoSkyMidBlue: UIColor {
        return customColor(red: 39, green: 190, blue: 224)
    }
    
    static var operandoSkyLightBlue: UIColor {
        return customColor(red: 91, green: 189, blue: 215)
    }
    
    static var operandoSkyTransparentLightBlue: UIColor {
        return customColor(red: 91, green: 189, blue: 215, alpha: 0.75)
    }
    
    static var operandoSkyGradientColors: [CGColor] {
        return [UIColor.operandoSkyBlue.cgColor,
        UIColor.operandoSkyBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor]
    }
}
