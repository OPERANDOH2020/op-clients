//
//  OPErrorContainer.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation



enum OPErrorCodes: Int
{
    case InvalidInput = 1
    case InvalidServerResponse = 2
}

let localizableKeysPerErrorCode: [Int: String] =
    [ OPErrorCodes.InvalidInput.rawValue: "kInvalidInputLocalizableKey",
      OPErrorCodes.InvalidServerResponse.rawValue : "kInvalidServerResponseLocalizableKey"
    ]

extension Bundle
{
    class func localizedStringFor(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


class OPErrorContainer
{
    static let kOperandoDomain = "com.operando.eu"
    
    
    static let errorInvalidInput: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.InvalidInput.rawValue, userInfo: nil)
    static let errorInvalidServerResponse: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.InvalidServerResponse.rawValue, userInfo: nil)
    
    
    static func displayError(error: NSError)
    {
        
        if error.domain == kOperandoDomain
        {
            let key = localizableKeysPerErrorCode[error.code] ?? ""
            let message = Bundle.localizedStringFor(key: key)
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: message)
            return
        }
        
        OPViewUtils.showOkAlertWithTitle(title: "", andMessage: error.localizedDescription)
    }
}
