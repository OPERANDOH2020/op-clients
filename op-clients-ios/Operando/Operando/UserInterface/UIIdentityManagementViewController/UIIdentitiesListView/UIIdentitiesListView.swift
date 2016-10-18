//
//  UIIdentitiesListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

typealias IdentityIndexCallback = ((_ item: String, _ index: Int ) -> Void)

struct UIIdentitiesListCallbacks
{
    let whenPressedToDeleteItemAtIndex: IdentityIndexCallback?
    let whenActivatedItemAtIndex: IdentityIndexCallback?
    
}

class UIIdentitiesListView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate
{
    
    private var identitiesList: [String] = []
    private var callbacks: UIIdentitiesListCallbacks?
    private var currentDefaultIdentityIndex: Int = 0
    
    @IBOutlet var tableView: UITableView?
    
    override func commonInit() {
        super.commonInit()
        self.setupTableView(tableView: self.tableView)
    }
    
    private func setupTableView(tableView: UITableView?)
    {
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let nib = UINib(nibName: UIIdentityCell.identifierNibName, bundle: nil);
        
        tableView?.register(nib, forCellReuseIdentifier: UIIdentityCell.identifierNibName);
        tableView?.rowHeight = 44;
        
        
    }
    
    func setupWith(initialList: [String], defaultIdentityIndex: Int, andCallbacks callbacks: UIIdentitiesListCallbacks?)
    {
        self.identitiesList = initialList
        self.currentDefaultIdentityIndex = defaultIdentityIndex
        self.callbacks = callbacks
        self.tableView?.reloadData()
    }
    
    
    func appendAndDisplayNew(item: String)
    {
        self.identitiesList.append(item)
        self.tableView?.insertRows(at: [IndexPath(row: self.identitiesList.count-1, section: 0)], with: .automatic)
    }
    
    func deleteItemAt(index: Int)
    {
        self.identitiesList.remove(at: index)
        self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func displayAsDefaultItemAt(index: Int)
    {
        guard index != self.currentDefaultIdentityIndex else{
            return
        }
        
        self.currentDefaultIdentityIndex = index
        self.tableView?.reloadData()
        
    }
    
    //MARK: tableView delegate and dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.identitiesList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIIdentityCell.identifierNibName) as! UIIdentityCell

        cell.setupWithIdentity(identity: self.identitiesList[indexPath.row], isDefault: indexPath.row == self.currentDefaultIdentityIndex)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.currentDefaultIdentityIndex
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard indexPath.row != self.currentDefaultIdentityIndex else {
            return nil
        }
        weak var welf = self
        
        let makeDefaultAction = UITableViewRowAction(style: .normal, title: "Default", handler: { action, idxPath in
            guard let item = welf?.identitiesList[idxPath.row] else {
                return
            }
            DispatchQueue.main.async {
                welf?.callbacks?.whenActivatedItemAtIndex?(item, idxPath.row)
            }
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { action, idxPath in
            guard let item = welf?.identitiesList[idxPath.row] else {
                return
            }
            DispatchQueue.main.async {
                welf?.callbacks?.whenPressedToDeleteItemAtIndex?(item, idxPath.row)
            }
        })
        
        makeDefaultAction.backgroundColor = UIColor(colorLiteralRed: 10.0/255.0, green: 96.0/255, blue: 254.0/255.0, alpha: 1.0)
        
        
        return [deleteAction, makeDefaultAction]
    }
}
