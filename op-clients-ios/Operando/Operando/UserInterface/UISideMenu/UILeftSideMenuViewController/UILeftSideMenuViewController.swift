//
//  UILeftSideMenuViewController.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let UILeftSideMenuViewControllerStoryboardId = "UILeftSideMenuViewControllerStoryboardId"

struct UILeftSideMenuViewControllerCallbacks {
    let dashboardCallbacks: UIDashBoardViewControllerCallbacks?
    let whenChoosingHome: VoidBlock?
}

class UILeftSideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    var callbacks: UILeftSideMenuViewControllerCallbacks?
    var dataSource: [UILeftSideMenuVCObject]? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.reloadData()
        }
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - @IBActions
    @IBAction func didTapProfileButton(_ sender: AnyObject) {
//        self.sideMenuViewController?.contentViewController = UINavigationManager.profileNavigationViewController
        self.sideMenuViewController?.hideMenuViewController()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource = getMenuDataSource()
    }
    
    // MARK: - Table View Data Source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UILeftSideMenuTableViewCellIdentifier, for: indexPath) as! UILeftSideMenuTableViewCell
        
        guard let dataSource = dataSource else { return cell }
        cell.setup(withObject: UILeftSideMenuTVCellObject(categoryImageName: dataSource[indexPath.row].categoryImageName, title: dataSource[indexPath.row].categoryName))
        
        return cell
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dataSource = dataSource else { return }
        dataSource[indexPath.row].action?()
    }
}
