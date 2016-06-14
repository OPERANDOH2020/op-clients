//
//  UIExternalConnectionsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIExternalConnectionsViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate
{
    
    var refreshControl: UIRefreshControl?
    private var connectionInfos: [ExternalConnectionInfo] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.reloadData()
    }
    
    private func setupTableView(tableView: UITableView)
    {
        let nib = UINib(nibName: UIExternalConnectionInfoCell.identifierNibName, bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: UIExternalConnectionInfoCell.identifierNibName);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = UIExternalConnectionInfoCell.desiredHeight;
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(self.refreshControl!)
    }
    
    
    private func displaySecurityEventsScreenIfAny(connectionInfo: ExternalConnectionInfo)
    {
        guard connectionInfo.reportedSecurityEvents.count > 0 else {return}
        let vc = UINavigationManager.securityEventsViewController
        vc.setupWithExternalConnectionInfo(connectionInfo)
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: -tableView datasource
    
    func reloadData()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ExternalConnectionsHelper.getCurrentConnectionsInfoWithCompletion { (result) in
            self.connectionInfos = result ?? [];
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            self.tableView.hidden = self.connectionInfos.count == 0
            self.refreshControl?.endRefreshing()
        }

    }
    
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
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.displaySecurityEventsScreenIfAny(self.connectionInfos[indexPath.row]);
        return false;
    }
    
    
    
}
