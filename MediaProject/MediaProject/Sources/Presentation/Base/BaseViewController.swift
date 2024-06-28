//
//  BaseViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import UIKit

import SnapKit

class BaseViewController: UIViewController {
    let viewTitle: String
    
    init(viewTitle: String) {
        self.viewTitle = viewTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavi(title: viewTitle)
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
    }
}
