//
//  MoviesSceneDIContainer.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit
import SwiftUI

public class ItemsSceneDIContainer {
    // MARK: - Persistent Storage
    lazy var itemsStorage: ItemsCDStorage = CoreDataStorage()
    
    init() {}
    
    // MARK: - Converters
    lazy var itemConverter = ItemConverter()
    lazy var errorConverter = ErrorConverter()
    
    // MARK: - Use Cases
    func makeItemsUseCase() -> ItemsUseCase {
        return DefaultItemsUseCase(APIService: ItemsAPI.self,
                                   itemsCDStorage: itemsStorage, itemConverter: itemConverter, errorConverter: errorConverter)
    }
}

extension ItemsSceneDIContainer: ItemsListVCsFactory {
    // MARK: - Items List
    func makeItemsListNavController(items: [UIItemData]) -> UINavigationController {
        return UINavigationController(rootViewController: makeItemsListViewController(items: items))
    }
    
    func makeItemsListViewController(items: [UIItemData]) -> UIViewController {
        return ItemsListViewController.create(with: makeItemsListViewModel(items: items), router: makeItemsListRouter())
    }
    
    func makeItemsListViewModel(items: [UIItemData]) -> ItemsListViewModel {
        return DefaultItemsListViewModel(itemsUseCase: makeItemsUseCase(), items: items)
    }
    
    func makeItemsListRouter() -> ItemsListRouter {
        return ItemsListRouter(itemsListVCsFactory: self)
    }
}

extension ItemsSceneDIContainer: ItemDetailsVCsFactory {
    
    // MARK: - Items List
    func makeItemDetailsViewController(item: UIItemData) -> UIViewController {
        return ItemDetailsViewController.create(with: makeItemDetailsViewModel(item: item), router: makeItemDetailsRouter())
    }
    
    func makeItemDetailsViewModel(item: UIItemData) -> ItemDetailsViewModel {
        return DefaultItemDetailsViewModel(itemsUseCase: makeItemsUseCase(), item: item)
    }
    
    func makeItemDetailsRouter() -> ItemDetailsRouter {
        return ItemDetailsRouter(itemDetailsVCsFactory: self)
    }
}

extension ItemsSceneDIContainer: EditItemVCsFactory {
    // MARK: - Items List
    func makeEditItemViewController(item: UIItemData?) -> UIViewController {
        return EditItemViewController.create(with: makeEditItemViewModel(item: item), router: makeEditItemRouter())
    }
    
    func makeEditItemViewModel(item: UIItemData?) -> EditItemViewModel {
        return DefaultEditItemViewModel(itemsUseCase: makeItemsUseCase(), item: item)
    }
    
    func makeEditItemRouter() -> EditItemRouter {
        return EditItemRouter(editItemVCsFactory: self)
    }
}
