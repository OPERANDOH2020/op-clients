//
//  SwarmClientProtocol.swift
//  SwarmClientTest
//
//  Created by Catalin Pomirleanu on 4/28/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

public protocol SwarmClientProtocol {
    
    func didFailedToCreateSocket(error: NSError)
    func didReceiveData(data: [AnyObject])
}
