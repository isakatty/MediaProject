//
//  VideoWebViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import UIKit
import WebKit

final class VideoWebViewController: BaseViewController {
    var viewModel: VideoWebViewModel
    
    private let webView = WKWebView()
    
    init(viewModel: VideoWebViewModel, viewTitle: String) {
        self.viewModel = viewModel
        
        super.init(viewTitle: viewTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    private func bindData() {
        viewModel.inputViewDidLoadTrigger.value = ()
        openWebView()
    }
    private func openWebView() {
        guard let url = URL(string: viewModel.outputWebView.value) else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func configureHierarchy() {
        view.addSubview(webView)
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
}
