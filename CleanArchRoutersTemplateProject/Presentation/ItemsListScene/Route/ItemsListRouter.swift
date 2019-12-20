//
//  ItemsListRouter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/20/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol ItemsListVCsFactory {
    func makeItemDetailsViewController(item: UIItemData) -> UIViewController
    func makeEditItemViewController(item: UIItemData?) -> UIViewController
}

protocol ItemsListRouterDelegate: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool)
}

class ItemsListRouter {
    weak var delegate: ItemsListRouterDelegate?
    private var itemsListVCsFactory: ItemsListVCsFactory!
    
    init(itemsListVCsFactory: ItemsListVCsFactory) {
        self.itemsListVCsFactory = itemsListVCsFactory
    }
    
    func presentDetails(with item: UIItemData) {
        let vc = itemsListVCsFactory.makeItemDetailsViewController(item: item)
        delegate?.pushToNavigationStack(vc, animated: true)
    }
    
    func presentCreateItem() {
        let vc = itemsListVCsFactory.makeEditItemViewController(item: nil)
        delegate?.pushToNavigationStack(vc, animated: true)
    }
}
