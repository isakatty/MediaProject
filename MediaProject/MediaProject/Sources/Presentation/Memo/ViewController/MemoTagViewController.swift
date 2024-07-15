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
        tf.addTarget(self, action: #selector(textFieldChanging), for: .editingChanged)
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
        configureNavigationRightBar(action: #selector(saveBtnTapped))
    }
    
    private func bindData() {
        tagViewModel.inputViewDidLoad.value = ()
        
        tagViewModel.outputTag.onNext { [weak self] tag in
            guard let self else { return }
            
            if let tag, !tag.isEmpty {
                self.tagTextField.text = tag
            }
        }
        tagViewModel.outputDismiss.bind { [weak self] isChanged in
            guard let self else { return }
            if isChanged {
                dismiss(animated: true)
            } else {
                showAlert(title: "뒤로가기", message: "태그 저장 없이 돌아가시겠습니까?", ok: "확인") { [weak self] in
                    guard let self else { return }
                    dismiss(animated: true)
                }
            }
        }
        tagViewModel.outputSave.bind { [weak self] text in
            guard let self else { return }
            if text != tagViewModel.tagString {
                tagViewModel.delegate?.passTag(tag: self.tagViewModel.outputTag.value)
            }
            dismiss(animated: true)
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
        // Trigger - 얘도 input, output으로 넘겨야할까?
        tagViewModel.inputBackBtnTrigger.value = ()
    }
    @objc private func textFieldChanged(_ sender: UITextField) {
        tagViewModel.outputTag.value = sender.text
        
        tagViewModel.inputTextFieldEndEditing.value = ()
    }
    @objc private func textFieldChanging(_ sender: UITextField) {
        tagViewModel.outputTag.value = sender.text
    }
    @objc private func saveBtnTapped() {
        if tagTextField.text != nil {
            tagViewModel.outputTag.value = tagTextField.text
            print("이건 원본: \(tagTextField.text)", "🔥", tagViewModel.outputTag.value)
            tagViewModel.inputSaveBtnTrigger.value = tagTextField.text
        }
    }
}
