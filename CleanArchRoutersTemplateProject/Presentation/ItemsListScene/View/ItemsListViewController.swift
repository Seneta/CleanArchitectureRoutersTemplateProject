//
//  ItemsListViewController.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class ItemsListViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    private lazy var dataSource: ItemsListDataSource = {
        let dataSource = ItemsListDataSource()
        dataSource.viewModel = viewModel
        dataSource.delegate = self
        return dataSource
    }()
    
    var viewModel: ItemsListViewModel!
    var router: ItemsListRouter! {
        didSet {
            router.delegate = self
        }
    }
    
    class func create(with viewModel: ItemsListViewModel, router: ItemsListRouter) -> ItemsListViewController {
        let view = ItemsListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.router = router
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNibs()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func registerNibs() {
        tableView.register(ItemCell.nib(), forCellReuseIdentifier: "ItemCell")
    }

    private func refreshData() {
        viewModel.refreshData { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        router.presentCreateItem()
    }

}

extension ItemsListViewController: ItemsListDataSourceDelegate {
    func didSelectItem(index: Int) {
        let item = viewModel.items[index]
        router.presentDetails(with: item)
    }
}

extension ItemsListViewController: ItemsListRouterDelegate {
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
