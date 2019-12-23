//
//  NSManagedObject+stringName.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/23/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
}
