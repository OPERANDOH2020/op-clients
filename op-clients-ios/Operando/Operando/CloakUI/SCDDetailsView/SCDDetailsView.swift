//
//  SCDDetailsView.swift
//  Operando
//
//  Created by Costin Andronache on 1/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

fileprivate protocol SectionSource: class, UITableViewDataSource {
    
}

fileprivate class UrlListSectionSource: NSObject, SectionSource {
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

fileprivate class SensorListSectionSource: NSObject, SectionSource {
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class SCDDetailsView: RSNibDesignableView, UITableViewDelegate, UITableViewDataSource {
   
    private var sectionSources: [SectionSource] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var scd: SCDDocument?
    
    
    
    func setupWith(scd: SCDDocument){
        self.scd = scd
    }
    
    
    
    private func setup(tableView: UITableView?){
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < self.sectionSources.count else {
            return 0
        }
        return self.sectionSources[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < self.sectionSources.count else {
            return UITableViewCell()
        }
        
        return self.sectionSources[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
}
