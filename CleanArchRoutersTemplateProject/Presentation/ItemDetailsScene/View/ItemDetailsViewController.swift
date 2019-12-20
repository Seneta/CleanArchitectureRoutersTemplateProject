//
//  ItemDetailsViewController.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, StoryboardInstantiable {
    var viewModel: ItemDetailsViewModel!
    var router: ItemDetailsRouter! {
        didSet {
            router.delegate = self
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func create(with viewModel: ItemDetailsViewModel, router: ItemDetailsRouter) -> ItemDetailsViewController {
        let view = ItemDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        view.router = router
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        refreshData()
    }
    
    private func updateUI() {
        titleLabel.text = viewModel.item.title
        descriptionLabel.text = viewModel.item.itemDescription
    }
    

    @IBAction func editTapped(_ sender: Any) {
        router.presentEditItem(with: viewModel.item)
    }
    
    private func refreshData() {
        viewModel.refreshData { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
}

extension ItemDetailsViewController: ItemDetailsRouterDelegate {
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
