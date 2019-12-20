//
//  EditItemRouter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/20/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol EditItemVCsFactory {}

protocol EditItemRouterDelegate: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool)
    func goBack(animated: Bool)
}

class EditItemRouter {
    private var editItemVCsFactory: EditItemVCsFactory!
    weak var delegate: EditItemRouterDelegate?
    
    init(editItemVCsFactory: EditItemVCsFactory) {
        self.editItemVCsFactory = editItemVCsFactory
    }
    
    func routeBack() {
        delegate?.goBack(animated: true)
    }
    
}

