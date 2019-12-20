//
//  EditItemViewModel.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol EditItemViewModel {
    var item: UIItemData { get set }
    func saveChanges(closure: @escaping (UIError?) -> Void)
}

class DefaultEditItemViewModel: EditItemViewModel {
    enum WorkingState {
        case edit
        case create
    }
    
    var workingState: WorkingState
    private let itemsUseCase: ItemsUseCase
    var item: UIItemData
    
    init(itemsUseCase: ItemsUseCase, item: UIItemData?) {
        self.itemsUseCase = itemsUseCase
        
        if let item = item {
            self.item = item
            self.workingState = .edit
        } else {
            let newItem = UIItemData()
            newItem.id = UUID().uuidString
            self.item = newItem
            self.workingState = .create
        }
    }
    
    func saveChanges(closure: @escaping (UIError?) -> Void) {
        switch workingState {
        case .create:
            let request = CreateItemUseCaseRequest(item: item)
            itemsUseCase.createItem(requestValue: request) { [weak self] (item, error) in
                guard let _ = self else { return }
                closure(error)
            }
        case .edit:
            guard let itemId = item.id else { return }
            
            let request = UpdateItemUseCaseRequest(itemId: itemId, item: item)
            itemsUseCase.updateItem(requestValue: request) { [weak self] (item, error) in
                guard let _ = self else { return }
                closure(error)
            }
 
        }
    }
}
