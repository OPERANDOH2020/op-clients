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
        
        let index = indexPath.row;
        let identity = self.identitiesList[index]
        weak var weakSelf = self;
        
        let whenSwitchActivated: VoidBlock? = (index == self.currentDefaultIdentityIndex) ? nil : {
            weakSelf?.callbacks?.whenActivatedItemAtIndex?(identity, index)
        }
        
        cell.setupWithIdentity(identity: self.identitiesList[index], whenDeletingButtonPressed: {
            
            if let item = weakSelf?.identitiesList[index]{
                weakSelf?.callbacks?.whenPressedToDeleteItemAtIndex?(item, index)
            }
        }, whenSwitchActivated: whenSwitchActivated)
        
        return cell;
    }
}
