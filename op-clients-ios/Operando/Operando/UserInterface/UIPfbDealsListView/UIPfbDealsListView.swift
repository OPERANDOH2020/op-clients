//
//  UIPfbDealsListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/18/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIPfbDealsListViewCallbacks{
    let whenSelectingCellWithDeal: ((_ cell: UIPfbDisplayingView?, _ deal: PfbDeal) -> Void)?
    let cellCallbacks: UIPfbDisplayingViewCallbacks?
}

class UIPfbDealsListView: RSNibDesignableView, UITableViewDelegate, UITableViewDataSource
{
    
    private var deals: [PfbDeal] = []
    private var callbacks: UIPfbDealsListViewCallbacks?
    
    @IBOutlet weak var tableView: UITableView?
    
    private func setupTableView(_ tableView: UITableView?){
        let nib = UINib(nibName: UIPfbDealTableViewCell.identifierNibName, bundle: nil)
        
        tableView?.register(nib, forCellReuseIdentifier: UIPfbDealTableViewCell.identifierNibName)
        
        tableView?.delegate = self
        tableView?.dataSource = self 
    }
    
    override func commonInit() {
        super.commonInit()
        self.setupTableView(self.tableView)
    }
    
    
    
    func setupWith(deals: [PfbDeal], andCalllbacks callbacks: UIPfbDealsListViewCallbacks? ){
        self.deals = deals
        self.callbacks = callbacks
        self.tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIPfbDealTableViewCell.identifierNibName) as! UIPfbDealTableViewCell
        let deal = self.deals[indexPath.row]
        
        cell.setupWith(model: deal, andCallbacks: self.callbacks?.cellCallbacks)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        DispatchQueue.main.async {
            let deal = self.deals[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as? UIPfbDealTableViewCell
            self.callbacks?.whenSelectingCellWithDeal?(cell, deal)
        }
        return false
    }
    
}
