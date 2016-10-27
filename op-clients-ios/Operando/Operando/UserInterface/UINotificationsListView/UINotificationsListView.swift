//
//  UINotificationsListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kDismissLocalizableKey = "kDismissLocalizableKey"

struct UINotificationsListViewCallbacks {
    let whenDismissingNotificationAtIndex: ((_ notification: OPNotification, _ index: Int) -> Void)?
}

class UINotificationsListView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate {

    

    
    private var notifications: [OPNotification] = []
    private var callbacks: UINotificationsListViewCallbacks?
    
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
    
    
    
    func setupWith(initialListOfNotifications: [OPNotification], callbacks: UINotificationsListViewCallbacks?){
        self.notifications = initialListOfNotifications
        self.callbacks = callbacks
    }
    
    
    func deleteNotification(at index: Int){
        guard index >= 0 && index < self.notifications.count else {
            return
        }
        
        self.notifications.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
    }
    
    
    //MARK: TableView 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UINotificationCell.identifierNibName, for: indexPath) as! UINotificationCell
        
        let notification = self.notifications[indexPath.row]
        
        cell.setupWith(notification: notification)
        
        weak var weakSelf = self
        
        
        cell.rightButtons = [ MGSwipeButton(title: Bundle.localizedStringFor(key: kDismissLocalizableKey), backgroundColor: UIColor.red, callback: { swipeCell -> Bool in
            
            swipeCell?.hideSwipe(animated: true, completion: { _ in
                weakSelf?.callbacks?.whenDismissingNotificationAtIndex?(notification, indexPath.row)
            })
            
            return true
        })! ]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
    
}
