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
    
    func configureNavigationLeftBar(action: Selector?) {
        if action != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: action
            )
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backBtnTapped)
            )
        }
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
    }
    func configureNavigationRightBar(action: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: action
        )
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
        message : String
    ) {
        // TODO: width를 동적으로 바꿀 수 있게 해야할듯. 지금 15pro 기준 중앙(아님)처럼 보이지만, 다른 frame으로 가면 안맞을것.
        let toastLabel = UILabel()
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.sizeToFit()
        
        let padding: CGFloat = 20.0
        let labelWidth = toastLabel.frame.width + padding * 2
        let labelHeight = toastLabel.frame.height + padding
        toastLabel.frame = CGRect(
            x: (self.view.frame.size.width - labelWidth) / 2,
            y: self.view.frame.size.height - 180,
            width: labelWidth,
            height: labelHeight
        )
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func showAlert(
        title: String,
        message: String,
        ok: String,
        handler: @escaping (() -> Void)
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
