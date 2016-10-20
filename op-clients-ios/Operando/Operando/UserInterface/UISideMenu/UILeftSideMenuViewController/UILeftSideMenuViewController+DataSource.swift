//
//  UILeftSideMenuViewController+DataSource.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

extension UILeftSideMenuViewController {
    
    struct UILeftSideMenuVCObject {
        var categoryImageName: String
        var categoryName: String
        var action: () -> Void
    }

    func getMenuDataSource() -> [UILeftSideMenuVCObject] {
        
        var result = [UILeftSideMenuVCObject]()
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "identitiesIcon", categoryName: "Identity Management", action: { [unowned self] in
            self.callbacks?.whenChoosingIdentitiesManagement?()
            }))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "dealsIcon", categoryName: "Privacy For Benefits", action: { [unowned self] in
            self.callbacks?.whenChoosingPrivacyForBenefits?()
            }))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "browsingIcon", categoryName: "Private Browsing", action: { [unowned self] in
            self.callbacks?.whenChoosingPrivateBrowsing?()
            }))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "notificationsIcon", categoryName: "Notifications", action: { [unowned self] in
            self.callbacks?.whenChoosingNotifications?()
            }))
        
        return result
    }
}
