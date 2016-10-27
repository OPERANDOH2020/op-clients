//
//  NotificationsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol NotificationsRepository {
    func getAllNotifications(in completion: ((_ notifications: [OPNotification], _ error: NSError?) -> Void)?)
    func dismiss(notification: OPNotification, withCompletion completion: CallbackWithError?)
}

class DummyNotificationsRepo: NotificationsRepository{
    
    func getAllNotifications(in completion: (([OPNotification], NSError?) -> Void)?) {
        
        var notifs: [OPNotification] = []
        for i in 1...25 {
            notifs.append(OPNotification(notificationsSwarmReplyDict: ["notificationId": "\(i)",
                                                                       "title": "notification \(i)",
                                                                       "description": "Description\(i)",
                                                                       "dismissed": false])!)
        }
        
        completion?(notifs, nil)
    }
    
    func dismiss(notification: OPNotification, withCompletion completion: CallbackWithError?) {
        completion?(nil)
    }
}
