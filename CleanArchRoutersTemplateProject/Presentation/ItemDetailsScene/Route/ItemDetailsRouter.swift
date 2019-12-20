//
//  ItemDetailsRouter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/20/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol ItemDetailsVCsFactory {
    func makeEditItemViewController(item: UIItemData?) -> UIViewController
}

protocol ItemDetailsRouterDelegate: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool)
}

class ItemDetailsRouter {
    private var itemDetailsVCsFactory: ItemDetailsVCsFactory!
    weak var delegate: ItemDetailsRouterDelegate?
    
    init(itemDetailsVCsFactory: ItemDetailsVCsFactory) {
        self.itemDetailsVCsFactory = itemDetailsVCsFactory
    }
    
    func presentEditItem(with item: UIItemData) {
        let vc = itemDetailsVCsFactory.makeEditItemViewController(item: item)
        delegate?.pushToNavigationStack(vc, animated: true)
    }
}
