//
//  UIMenuTableViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

typealias VoidBlock = (() -> ())

class UIMenuTableViewController: UITableViewController
{
    
    var actionsPerIndex: [Int : VoidBlock] = [:]
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if let action = self.actionsPerIndex[indexPath.row]
        {
            action();
        }
    }
    
}
