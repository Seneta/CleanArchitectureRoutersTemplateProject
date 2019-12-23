//
//  ItemsUseCase.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit
import CoreData

protocol ItemsAPIService: class {
    static func getItem(id: String, closure: @escaping (APIItemData?, Error?) -> Void )
    static func getItems(closure: @escaping ([APIItemData]?, Error?) -> Void )
    static func createItem(_ item: APIItemData, closure: @escaping (APIItemData?, Error?) -> Void )
    static func updateItem(_ item: APIItemData, closure: @escaping (APIItemData?, Error?) -> Void )
}

protocol ItemsCDStorage {
    func getItem(id: String, closure: @escaping (CDItemData?) -> Void )
    func getItems(closure: @escaping ([CDItemData]?) -> Void )
    func createItem() -> CDItemData?
    func saveChanges()
    var context: NSManagedObjectContext { get }
}

protocol ItemsUseCase {
    func getItem(requestValue: GetItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void)
    func getItems(closure: @escaping ([UIItemData]?, UIError?) -> Void)
    func createItem(requestValue: CreateItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void)
    func updateItem(requestValue: UpdateItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void)
}

class DefaultItemsUseCase: ItemsUseCase {
    private var itemsAPIService: ItemsAPIService.Type
    private var itemsCDStorage: ItemsCDStorage
    private let notificationCenter = NotificationCenter.default
    
    private let itemConverter: ItemConverter
    private let errorConverter: ErrorConverter
    
    init(APIService: ItemsAPIService.Type, itemsCDStorage: ItemsCDStorage, itemConverter: ItemConverter, errorConverter: ErrorConverter) {
        self.itemsAPIService = APIService
        self.itemsCDStorage = itemsCDStorage
        self.itemConverter = itemConverter
        self.errorConverter = errorConverter
    }
    
    func getItem(requestValue: GetItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void) {
        itemsCDStorage.getItem(id: requestValue.id) { [weak self] cdItem in
            guard let self = self else { return }
            
            if let cdItem = cdItem {
                let item = self.itemConverter.convertToItem(cdItem)
                closure(item, nil)
            } else {
                self.itemsAPIService.getItem(id: requestValue.id) { [weak self] (apiItem, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        let uiError = self.errorConverter.convertToUIError(error)
                        closure(nil, uiError)
                    } else if let apiItem = apiItem {
                        let item = self.itemConverter.convertToItem(apiItem)
                        
                        if let cdItem = self.itemsCDStorage.createItem() {
                            self.itemConverter.convert(item, toCDItem: cdItem)
                            self.itemsCDStorage.saveChanges()
                        }
                        
                        
                        closure(item, nil)
                    } else {
                        closure(nil, nil)
                    }
                }
            }
        }
    }
    
    func getItems(closure: @escaping ([UIItemData]?, UIError?) -> Void) {
        itemsCDStorage.getItems() { [weak self] cdItems in
            guard let self = self else { return }
                
            if let cdItems = cdItems, cdItems.count > 0 {
                let items = cdItems.map { self.itemConverter.convertToItem($0) }
                closure(items, nil)
            } else {
                self.itemsAPIService.getItems() { [weak self] (apiItems, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        let uiError = self.errorConverter.convertToUIError(error)
                        closure(nil, uiError)
                    } else if let apiItems = apiItems {
                        let items = apiItems.map { self.itemConverter.convertToItem($0) }
                        
                        items.forEach {
                            if let cdItem = self.itemsCDStorage.createItem() {
                                self.itemConverter.convert($0, toCDItem: cdItem)
                            }
                            
                        }
                        self.itemsCDStorage.saveChanges()
                        
                        closure(items, nil)
                    } else {
                        closure(nil, nil)
                    }
                }
            }
        }
    }
    
    func createItem(requestValue: CreateItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void) {
        let apiItem = itemConverter.convertToAPIItem(requestValue.item)
        
        itemsAPIService.createItem(apiItem) { [weak self] (apiItem, error) in
            guard let self = self else { return }
            
            if let error = error {
                let uiError = self.errorConverter.convertToUIError(error)
                closure(nil, uiError)
            } else if let apiItem = apiItem {
                let item = self.itemConverter.convertToItem(apiItem)
                
                if let cdItem = self.itemsCDStorage.createItem() {
                    self.itemConverter.convert(item, toCDItem: cdItem)
                    self.itemsCDStorage.saveChanges()
                }
                
                if let itemID = apiItem.id {
                    self.sendUpdateItemNotification(itemId: itemID)
                }
                
                closure(item, nil)
            } else {
                closure(nil, nil)
            }
        }
    }
        
    func updateItem(requestValue: UpdateItemUseCaseRequest, closure: @escaping (UIItemData?, UIError?) -> Void) {
        let apiItem = itemConverter.convertToAPIItem(requestValue.item)
        
        itemsAPIService.updateItem(apiItem) { [weak self] (apiItem, error) in
            guard let self = self else { return }
            
            if let error = error {
                let uiError = self.errorConverter.convertToUIError(error)
                closure(nil, uiError)
            } else if let apiItem = apiItem {
                let item = self.itemConverter.convertToItem(apiItem)
                
                self.itemsCDStorage.getItem(id: requestValue.itemId) { [weak self] cdItem in
                    guard let self = self else { return }
                    
                    if let cdItem = cdItem {
                        self.itemConverter.convert(item, toCDItem: cdItem)
                    } else {
                        if let cdItem = self.itemsCDStorage.createItem() {
                            self.itemConverter.convert(item, toCDItem: cdItem)
                        }
                    }
                    
                    self.itemsCDStorage.saveChanges()
                    self.sendUpdateItemNotification(itemId: requestValue.itemId)
                    closure(item, nil)
                }
                
                
            } else {
                closure(nil, nil)
            }
        }
    }
    
    private func sendUpdateItemNotification(itemId: String) {
        let notification = Notification(name: AppNotificationType.updateItem.name(), object: nil, userInfo: ["itemId": itemId])
        notificationCenter.post(notification)
    }

}

struct GetItemUseCaseRequest {
    let id: String
}

struct CreateItemUseCaseRequest {
    let item: UIItemData
}

struct UpdateItemUseCaseRequest {
    let itemId: String
    let item: UIItemData
}

struct MakeUpdateItemObserverRequest {
    let observer: Any
    let selector: Selector
    let itemId: String
}

