//
//  UIAddIdentityView.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIAddIdentityViewCallbacks{
    let whenPressedClose: VoidBlock?
    let whenPressedSave: VoidBlock?
    let whenPressedRefresh: VoidBlock?
}

class UIAddIdentityView: RSNibDesignableView, UITableViewDelegate, UITableViewDataSource
{
    let cellIdentitifer = "domainCellIdentifier"
    private var domains: [Domain] = []
    private var currentlyShownDomains: [Domain] = []
    private var selectedDomainIndex: Int = 0
    
    private var callbacks: UIAddIdentityViewCallbacks?
    
    
    
    @IBOutlet weak var aliasTF: UITextField!
    @IBOutlet weak var domainTF: UITextField!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var domainsTableView: UITableView!
    
    
    private func setupTableView(tv: UITableView?)
    {
        tv?.delegate = self
        tv?.dataSource = self
        tv?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentitifer)
    }
    
    
    
    
    
    
    
    
    
    //MARK: tableView delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentlyShownDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitifer) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentitifer)
        
        cell.textLabel?.text = self.currentlyShownDomains[indexPath.row].name
        
        return cell
    }
    
}
