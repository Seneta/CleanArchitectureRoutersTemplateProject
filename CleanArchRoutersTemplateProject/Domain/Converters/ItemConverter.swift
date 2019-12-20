//
//  ItemConverter.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class ItemConverter: NSObject {
    func convert(_ item: UIItemData, toCDItem cdItem: CDItemData) {
        cdItem.id = item.id
        cdItem.title = item.title
        cdItem.itemDescription = item.itemDescription
    }
    
    func convertToItem(_ cdItem: CDItemData) -> UIItemData {
        let item = UIItemData()
        item.id = cdItem.id
        item.title = cdItem.title
        item.itemDescription = cdItem.itemDescription
        return item
    }
    
    func convertToItem(_ apiItem: APIItemData) -> UIItemData {
        let item = UIItemData()
        item.id = apiItem.id
        item.title = apiItem.title
        item.itemDescription = apiItem.itemDescription
        return item
    }
    
    func convertToAPIItem(_ item: UIItemData) -> APIItemData {
        let apiItem = APIItemData()
        apiItem.id = item.id
        apiItem.title = item.title
        apiItem.itemDescription = item.itemDescription
        return apiItem
    }
}
