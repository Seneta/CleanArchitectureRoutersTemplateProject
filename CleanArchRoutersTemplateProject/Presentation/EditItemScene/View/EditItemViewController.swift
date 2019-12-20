//
//  EditItemViewController.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/19/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, StoryboardInstantiable {
    var viewModel: EditItemViewModel!
    var router: EditItemRouter! {
        didSet {
            router.delegate = self
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
           didSet {
            descriptionTextView.delegate = self
           }
       }
    
    class func create(with viewModel: EditItemViewModel, router: EditItemRouter) -> EditItemViewController {
        let view = EditItemViewController.instantiateViewController()
        view.viewModel = viewModel
        view.router = router
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    private func updateUI() {
        titleTextField.text = viewModel.item.title
        descriptionTextView.text = viewModel.item.itemDescription
    }

    @IBAction func saveTapped(_ sender: Any) {
        viewModel.saveChanges() { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.router.routeBack()
                }
            } else {
                //
            }
            
        }
        
    }
}

extension EditItemViewController: EditItemRouterDelegate {
    func pushToNavigationStack(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func goBack(animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
}

extension EditItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        viewModel.item.title = text
        return true
    }
}
extension EditItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.item.itemDescription = textView.text
    }
}
