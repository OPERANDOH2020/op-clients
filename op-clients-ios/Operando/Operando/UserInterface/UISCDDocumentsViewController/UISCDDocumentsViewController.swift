//
//  UISCDDocumentsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UISCDDocumentsViewControllerModel {
    let repository: SCDRepository
}

struct UISCDDocumentsViewControllerCallbacks {
    let whenUserSelectsSCD: ((_ scd: SCDDocument) -> Void)?
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
        self.model?.repository.retrieveAllDocuments({ documents, error  in
            if let documents = documents {
                self.documentsFromRepository = documents
                self.cellAtIndexNeedsFullSize = Array<Bool>(repeating: false, count: self.documentsFromRepository.count)
                self.tableView?.reloadData()
            }
        })
    }
    
    private func setup(tableView: UITableView?){
        let nib = UINib(nibName: SCDDocumentCell.identifierNibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: SCDDocumentCell.identifierNibName)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
    
    
    //MARK: TableView related
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentsFromRepository.count
    }
    
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        
        let document = self.documentsFromRepository[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDDocumentCell.identifierNibName, for: indexPath) as! SCDDocumentCell
        cell.setup(with: self.documentsFromRepository[indexPath.row],
                   inFullSize: self.cellAtIndexNeedsFullSize[indexPath.row],
                   callbacks: SCDDocumentCellCallbacks(
            whenUserSelectsAdvanced: {weakSelf?.callbacks?.whenUserSelectsSCD?(document)},
            whenRequiresResize: { needsFullSize in
                weakSelf?.cellAtIndexNeedsFullSize[indexPath.row] = needsFullSize
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
