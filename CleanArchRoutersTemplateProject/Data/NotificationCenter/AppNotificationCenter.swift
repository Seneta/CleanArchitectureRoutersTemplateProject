//
//  AppNotificationCenter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/23/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit
import CoreData

enum AppNotificationType: String {
    case updateItem
    
    func name() -> Notification.Name {
        return Notification.Name(self.rawValue)
    }
}

struct TypifiedFRC {
    let frc: NSFetchedResultsController<NSFetchRequestResult>
    let notification: Notification
}

class CDChangesNotificationCenter: NSObject {
    let notificationCenter = NotificationCenter.default
    private var frcList = [TypifiedFRC]()
    
    func addForObservation(_ frc: NSFetchedResultsController<NSFetchRequestResult>, notification: Notification) {
        frc.delegate = self
        let typifiedFRC = TypifiedFRC(frc: frc, notification: notification)
        frcList.append(typifiedFRC)
    }
    
    func clearFRCsList() {
        frcList.removeAll()
    }
    
    func checkIfExists(_ notification: Notification) -> Bool {
        return frcList.map { $0.notification.name }.contains(notification.name)
    }
    
    func addObserver(_ observer: Any, selector: Selector, notification: Notification) {
        notificationCenter.addObserver(observer, selector: selector, name: notification.name, object: nil)
    }
}

extension CDChangesNotificationCenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        frcList.forEach {
            if $0.frc == controller {
                notificationCenter.post($0.notification)
            }
        }
    }
}
