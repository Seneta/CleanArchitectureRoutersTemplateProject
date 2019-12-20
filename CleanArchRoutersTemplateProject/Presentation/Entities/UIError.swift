//
//  UIError.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class UIError {
    enum ErrorType {
        case server
        case timout
        case other
    }
    
    var type: ErrorType
    
    init(type: ErrorType) {
        self.type = type
    }
}
