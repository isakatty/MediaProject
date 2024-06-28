//
//  UIViewController+.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

extension UIViewController {
    func configureNavi(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backBtnTapped)
        )
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
}
