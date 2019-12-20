//
//  ItemsAPI.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class ItemsAPI: ItemsAPIService {
    static func getItems(closure: @escaping ([APIItemData]?, Error?) -> Void ) {
        var items = [APIItemData]()
        let ids = 0...20
        ids.forEach {
            let item = APIItemData()
            item.id = "\($0)"
            item.title = "Item # \($0)"
            item.itemDescription = "Its item # \($0) description \n and some \n more of text"
            items.append(item)
        }
        
        closure(items, nil)
    }
    
    static func getItem(id: String, closure: @escaping (APIItemData?, Error?) -> Void ) {
        let item = APIItemData()
        item.id = "\(id)"
        item.title = "Item # \(id)"
        item.itemDescription = "Its item # \(id) description \n and some \n more of text"
        
        closure(item, nil)
    }
    
    static func createItem(_ item: APIItemData, closure: @escaping (APIItemData?, Error?) -> Void ) {
        closure(item, nil)
    }
    
    static func updateItem(_ item: APIItemData, closure: @escaping (APIItemData?, Error?) -> Void ) {
        closure(item, nil)
    }
}
