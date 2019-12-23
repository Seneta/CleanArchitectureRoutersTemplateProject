//
//  ItemDetailsViewModel.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol ItemDetailsViewModel {
    var item: UIItemData { get }
    func refreshData(closure: @escaping ( UIError?) -> Void)
    var didUpdateData: (() -> Void)? { get set }
}

class DefaultItemDetailsViewModel: ItemDetailsViewModel {
    private let itemsUseCase: ItemsUseCase
    private(set) var item: UIItemData
    
    var didUpdateData: (() -> Void)?
    
    private let notificationCenter = NotificationCenter.default
    
    
    init(itemsUseCase: ItemsUseCase, item: UIItemData) {
        self.itemsUseCase = itemsUseCase
        self.item = item
        notificationCenter.addObserver(self, selector: #selector(didReceiveRefreshNotification(_:)), name: AppNotificationType.updateItem.name(), object: nil)
    }
    
    func refreshData(closure: @escaping ( UIError?) -> Void) {
        guard let itemId = item.id else {
            closure(UIError(type: .other))
            return
        }
        
        let requestValue = GetItemUseCaseRequest(id: itemId)
        itemsUseCase.getItem(requestValue: requestValue) { [weak self] (item, error) in
            guard let self = self else { return }
            
            if let item = item {
                self.item = item
            }
            
            closure(error)
        }
    }
    
    @objc func didReceiveRefreshNotification(_ notification: Notification) {
        if let itemId = notification.userInfo?["itemId"] as? String {
            if itemId == item.id {
                refreshData { [weak self] (error) in
                    guard let self = self else { return }
                    self.didUpdateData?()
                }
            }
        }
    }
}


