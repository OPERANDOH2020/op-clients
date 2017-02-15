//
//  UISCDDocumentsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PlusPrivacyCommonTypes

@objc
public protocol SCDRepository {
    func retrieveAllDocuments(with callback: ((_ documents: [SCDDocument]?, _ error: NSError?) -> Void)?)
}

struct UISCDDocumentsViewControllerModel {
    let repository: SCDRepository
}


struct UISCDDocumentsViewControllerCallbacks {
    let whenUserSelectsSCD: ((_ scd: SCDDocument) -> Void)?
    let whenUserSelectsToExit: VoidBlock?
}

class UISCDDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView?
    
    private var model: UISCDDocumentsViewControllerModel?
    private var callbacks: UISCDDocumentsViewControllerCallbacks?
    private var documentsFromRepository: [SCDDocument] = []
    private var cellAtIndexNeedsFullSize: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(tableView: self.tableView)
    }

    
    func setup(with model: UISCDDocumentsViewControllerModel, callbacks: UISCDDocumentsViewControllerCallbacks){
        self.callbacks = callbacks
        self.model = model
        let _ = self.view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.model?.repository.retrieveAllDocuments(with: { documents, error  in
            if let documents = documents {
                self.documentsFromRepository = documents
                self.cellAtIndexNeedsFullSize = Array<Bool>(repeating: false, count: self.documentsFromRepository.count)
                self.tableView?.reloadData()
            }
        })
    }
    
    private func setup(tableView: UITableView?){
        let nib = UINib(nibName: SCDDocumentCell.identifierNibName, bundle: Bundle(for: UISCDDocumentsViewController.self))
        tableView?.register(nib, forCellReuseIdentifier: SCDDocumentCell.identifierNibName)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
    
    @IBAction func didPressToExit(_ sender: Any) {
        self.callbacks?.whenUserSelectsToExit?()
    }
    
    //MARK: TableView related
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentsFromRepository.count
    }
    
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = self.documentsFromRepository[indexPath.row]
        weak var weakSelf = self
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDDocumentCell.identifierNibName, for: indexPath) as! SCDDocumentCell
        
        cell.setup(with: document,
                   inFullSize: self.cellAtIndexNeedsFullSize[indexPath.row],
                   callbacks: SCDDocumentCellCallbacks(whenUserSelectsAdvanced: { 
                    weakSelf?.callbacks?.whenUserSelectsSCD?(document)
                   }, whenRequiresResize: { flag in
                    weakSelf?.cellAtIndexNeedsFullSize[indexPath.row] = flag
                    weakSelf?.tableView?.beginUpdates()
                    weakSelf?.tableView?.endUpdates()
                   }))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellAtIndexNeedsFullSize[indexPath.row] ? UITableViewAutomaticDimension : 90.0;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
