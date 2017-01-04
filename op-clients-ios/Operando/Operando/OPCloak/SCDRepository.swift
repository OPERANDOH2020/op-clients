//
//  SCDRepository.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

typealias SCDDocumentCallback = (_ scd: SCDDocument?, _ error: NSError?) -> Void
typealias ErrorCallback = (_ error: NSError?) -> Void

protocol SCDRepository {
    func registerSCDJson(_ json: [String: Any], withCompletion completion: ErrorCallback?)
    func retrieveSCDDocument(basedOnBundleId id: String, withCompletion completion: SCDDocumentCallback?)
    func retrieveAllDocuments(_ completion: ((_ documents: [SCDDocument]?, _ error: NSError?) -> Void)?)
}



class PlistSCDRepository: SCDRepository {
    
    private let plistFilePath: String
    private var scdDocuments: [SCDDocument]
    private var scdJSONS: [[String: Any]]
    
    init(plistFilePath: String) {
        self.plistFilePath = plistFilePath
        self.scdDocuments = []
        self.scdJSONS = []
    }
    
    private func loadPlistObjects() {
        guard let plistArray = NSArray(contentsOfFile: self.plistFilePath),
              let plistDictsArray = plistArray as? [[String : Any]],
              let scdDocuments = SCDDocument.buildFromJSON(array: plistDictsArray) else {
                return
        }
        
        self.scdDocuments = scdDocuments
        self.scdJSONS = plistDictsArray
    }
    
    internal func retrieveAllDocuments(_ completion: (([SCDDocument]?, NSError?) -> Void)?) {
        completion?(self.scdDocuments, nil)
    }

    internal func retrieveSCDDocument(basedOnBundleId id: String, withCompletion completion: SCDDocumentCallback?) {
        let item = self.scdDocuments.first { doc -> Bool in
            return doc.bundleId == id
        }
        
        completion?(item, nil)
    }

    internal func registerSCDJson(_ json: [String : Any], withCompletion completion: ErrorCallback?) {
        guard let scdDocument = SCDDocument(scd: json) else {
            return
        }
        self.scdJSONS.append(json)
        self.scdDocuments.append(scdDocument)
        completion?(nil)
    }

    
    private func synchronize() {
        (self.scdJSONS as NSArray).write(toFile: self.plistFilePath, atomically: true)
    }
}
