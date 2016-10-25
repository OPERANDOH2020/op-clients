//
//  UINotificationsListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationsListView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate {

    
    private static let dummyNotifications: [String] = ["You have subscribed for 9gag.com",
                                                       "You have succesfully changed your password",
                                                       "You have created a new identity: xczdfg@op0.eu",
                                                       "You have unsubscribed from etsy.com",
                                                       "You have succesfully removed the identity: 3f56gxz@op1.eu",
                                                       "You have set 085fxpfl@op3.eu as your default identity"]
    
    private var notifications: [String] = UINotificationsListView.dummyNotifications
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
        self.setupTableView(tableView: self.tableView)
    }
    
    private func setupTableView(tableView: UITableView?){
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 44
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        let nib = UINib(nibName: UINotificationCell.identifierNibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: UINotificationCell.identifierNibName)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UINotificationCell.identifierNibName, for: indexPath) as! UINotificationCell
        
        cell.setupWith(notificationText: self.notifications[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
}
