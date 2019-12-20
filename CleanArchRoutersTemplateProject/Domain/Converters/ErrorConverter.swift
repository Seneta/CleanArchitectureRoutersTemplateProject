//
//  ErrorConverter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit
    


class ErrorConverter: NSObject {
    func convertToUIError(_ error: Error) -> UIError {
        return UIError(type: .server)
    }
    
}
