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
    
    static var operandoBlue: UIColor {
        return customColor(red: 44, green: 99, blue: 210)
    }
    
    static var operandoMidBlue: UIColor {
        return customColor(red: 66, green: 125, blue: 209)
    }
    
    static var operandoLightBlue: UIColor {
        return customColor(red: 98, green: 151, blue: 218)
    }
    
    static var operandoGreen: UIColor {
        return customColor(red: 9, green: 112, blue: 84)
    }
}
