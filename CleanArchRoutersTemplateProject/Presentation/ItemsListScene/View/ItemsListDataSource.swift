//
//  ItemsListDataSource.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

protocol ItemsListDataSourceDelegate: class {
    func didSelectItem(index: Int)
}

class ItemsListDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: ItemsListDataSourceDelegate?
    var viewModel: ItemsListViewModel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setupWith(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(index: indexPath.row)
    }
    
    
    
}
