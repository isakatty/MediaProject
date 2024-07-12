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
    func showToast(
        message : String,
        font: UIFont = UIFont.systemFont(ofSize: 14.0)
    ) {
        // TODO: width를 동적으로 바꿀 수 있게 해야할듯. 지금 15pro 기준 중앙(아님)처럼 보이지만, 다른 frame으로 가면 안맞을것.
        let toastLabel = UILabel(
            frame: CGRect(
                x: self.view.frame.size.width/5,
                y: self.view.frame.size.height - 260,
                width: 280,
                height: 35
            )
        )
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
