//
//  MemoTagViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import UIKit

final class MemoTagViewController: BaseViewController {
    let tagViewModel: MemoTagViewModel
    
    private lazy var tagTextField: MemoTextField = {
        let tf = MemoTextField(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        tf.placeholder = "제목을 입력하세요."
        tf.font = Constant.Font.regular14
        tf.textColor = .black
        tf.addTarget(
            self,
            action: #selector(textFieldChanged),
            for: .editingDidEndOnExit
        )
        return tf
    }()
    init(tagViewModel: MemoTagViewModel, viewTitle: String) {
        self.tagViewModel = tagViewModel
        
        super.init(viewTitle: viewTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        configureNavigationLeftBar(action: #selector(customBackBtnTapped))
    }
    
    private func bindData() {
        tagViewModel.inputViewDidLoad.value = ()
        
        tagViewModel.outputTag.onNext { [weak self] tag in
            guard let self else { return }
            
            if let tag, !tag.isEmpty {
                self.tagTextField.text = tag
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(tagTextField)
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        tagTextField.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
    }
    
    @objc private func customBackBtnTapped() {
        print("하이루")
        // Trigger
        navigationController?.popViewController(animated: true)
    }
    @objc private func textFieldChanged(_ sender: UITextField) {
        tagViewModel.outputTag.value = sender.text
        tagViewModel.delegate?.passTag(tag: sender.text)
        dismiss(animated: true)
    }
}
