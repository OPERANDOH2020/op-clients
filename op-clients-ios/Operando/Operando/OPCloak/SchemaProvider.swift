//
//  SchemaProvider.swift
//  Operando
//
//  Created by Costin Andronache on 12/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

typealias SchemaCallback = (_ schema: [String: Any]?, _ error: NSError?) -> Void
protocol SchemaProvider {
    func getSchemaWithCallback(_ callback: SchemaCallback?)
}


class LocalFileSchemaProvider: SchemaProvider {
    
    let pathToFile: String
    
    init(pathToFile: String) {
        self.pathToFile = pathToFile
    }
    
    func getSchemaWithCallback(_ callback: SchemaCallback?) {
        guard let fileAsString = try? String(contentsOfFile: self.pathToFile),
            let data = fileAsString.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return
        }
    }
}
