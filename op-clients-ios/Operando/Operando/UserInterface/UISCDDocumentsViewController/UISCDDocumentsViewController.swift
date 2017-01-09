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

class UISCDDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView?
    
    private var model: UISCDDocumentsViewControllerModel?
    private var documentsFromRepository: [SCDDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(tableView: self.tableView)
    }

    
    func setup(with model: UISCDDocumentsViewControllerModel){
        self.model = model
        let _ = self.view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.model?.repository.retrieveAllDocuments({ documents, error  in
            if let documents = documents {
                self.documentsFromRepository = documents
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDDocumentCell.identifierNibName, for: indexPath) as! SCDDocumentCell
        cell.setup(with: self.documentsFromRepository[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74;
    }
    
}
