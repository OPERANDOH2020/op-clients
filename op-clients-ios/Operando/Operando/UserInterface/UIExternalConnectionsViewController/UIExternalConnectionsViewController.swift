//
//  UIExternalConnectionsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIExternalConnectionsViewController: UIViewController,
UITableViewDataSource
{
    
    private var connectionInfos: [ExternalConnectionInfo] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ExternalConnectionsHelper.getCurrentConnectionsInfoWithCompletion { (result) in
            self.connectionInfos = result ?? [];
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            self.tableView.hidden = self.connectionInfos.count == 0
        }
    }
    
    private func setupTableView(tableView: UITableView)
    {
        let nib = UINib(nibName: UIExternalConnectionInfoCell.identifierNibName, bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: UIExternalConnectionInfoCell.identifierNibName);
        tableView.dataSource = self;
        tableView.rowHeight = UIExternalConnectionInfoCell.desiredHeight;
    }
    
    
    //MARK: -tableView datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionInfos.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UIExternalConnectionInfoCell.identifierNibName) as! UIExternalConnectionInfoCell
        cell.displayExternalConnectionInfo(self.connectionInfos[indexPath.row]);
        return cell;
    }
    
    
    
}
