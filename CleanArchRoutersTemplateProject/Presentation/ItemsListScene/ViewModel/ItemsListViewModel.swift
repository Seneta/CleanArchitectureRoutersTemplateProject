//
//  ItemsListViewModel.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol ItemsListViewModel {
    var items: [UIItemData] { get }
    func refreshData(closure: @escaping (UIError?) -> Void)
}

class DefaultItemsListViewModel: ItemsListViewModel {
    private let itemsUseCase: ItemsUseCase
    private(set) var items: [UIItemData]
    
    init(itemsUseCase: ItemsUseCase, items: [UIItemData]) {
        self.itemsUseCase = itemsUseCase
        self.items = items
    }
    
    func refreshData(closure: @escaping ( UIError?) -> Void) {
        itemsUseCase.getItems { [weak self] (items, error) in
            guard let self = self else { return }
            
            if let items = items {
                self.items = items
            }
            
            closure(error)
        }
    }
}
