//
//  UIIdentityManagementViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIdentityManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    private var identitiesList : [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.identitiesList = self.dummyIdentities();
        self.setupTableView(tableView: self.tableView);
    }
    
    
    private func setupTableView(tableView: UITableView?)
    {
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let nib = UINib(nibName: UIIdentityCell.identifierNibName, bundle: nil);
        
        tableView?.register(nib, forCellReuseIdentifier: UIIdentityCell.identifierNibName);
        tableView?.rowHeight = 44;
    }
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewSID(sender: AnyObject)
    {
        let item = "rr0ky5p1c0@operando7.eu";
        self.addNewItem(item: item);
        self.displayAlertForItem(item: item, withTitle: "New SID generated", addCancelAction: false, withConfirmation: nil);
    }
    
    
    //MARK: tableView delegate / datasource
    
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
        weak var weakSelf = self;
        
        weak var  weakCell = cell;
        weak var  weakTV = tableView;
        cell.setupWithIdentity(identity: self.identitiesList[index])
        {
            if let tvCell = weakCell, let tvCellIndexPath = weakTV?.indexPath(for: tvCell)
            {
                weakSelf?.deleteItemAtIndex(index: tvCellIndexPath.row);
            }
        }
        
        return cell;
    }
    
    
    
    //MARK: helper
    
    
    private func displayAlertForItem(item: String, withTitle title: String, addCancelAction:Bool, withConfirmation confirmation: (() -> ())?)
    {
        let alert = UIAlertController(title: title, message: item, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            confirmation?();
        }
        alert.addAction(okAction);
        
        if addCancelAction
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(cancelAction);
        }
        
        self.present(alert, animated: true, completion: nil);
    }
    
    private func deleteItemAtIndex(index: Int)
    {
        let sid = self.identitiesList[index];
        
        self.displayAlertForItem(item: sid, withTitle: "Do you want to delete this SID?", addCancelAction: true) {
            if let index = self.identitiesList.index(of: sid)
            {
                self.identitiesList.remove(at: index);
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade);
            }
        }
    }
    
    
    private func addNewItem(item: String)
    {
        self.identitiesList.append(item);
        self.tableView.insertRows(at: [IndexPath(row: self.identitiesList.count-1, section: 0)], with: .right);
    }
    
    private func dummyIdentities() -> [String]
    {
        return ["g67ash@operando.eu",
                "jd8skg@operando.eu",
                "9dsfdsg8@operando.eu"];
    }
}
