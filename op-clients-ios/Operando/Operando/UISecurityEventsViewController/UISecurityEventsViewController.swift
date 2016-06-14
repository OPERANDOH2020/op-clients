//
//  UISecurityEventsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISecurityEventsViewController: UIViewController,
    UITableViewDataSource
{
    
    @IBOutlet weak var securityEventsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var info: ExternalConnectionInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(self.tableView)
    }
    
    func setupWithExternalConnectionInfo(info: ExternalConnectionInfo)
    {
        let _ = self.view;
        guard let ip = info.connectionPair.address else {return}
        
        self.info = info;
        self.securityEventsLabel.text = "The following security events have been reported for \(ip) by Cymon.io";
        self.tableView.reloadData()
    }
    
    private func setupTableView(tv: UITableView)
    {
        let nib = UINib(nibName: UISecurityEventCell.idenitiferNibName, bundle: nil)
        tv.registerNib(nib, forCellReuseIdentifier: UISecurityEventCell.idenitiferNibName)
        tv.dataSource = self
        tv.estimatedRowHeight = 170;
    }
    
    
    //MARK: -tableView datasource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        guard let _ = self.info?.reportedSecurityEvents else {return 0}
        
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = self.info?.reportedSecurityEvents else {return 0}
        
        return events.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UISecurityEventCell.idenitiferNibName) as! UISecurityEventCell
        
        if let events = self.info?.reportedSecurityEvents
        {
            cell.setupWithSecurityEvent(events[indexPath.row]);
        }
        
        return cell
    }
}
