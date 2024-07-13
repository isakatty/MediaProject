//
//  MemoDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

enum BasicBtn: CaseIterable {
    case date, tag
    
    var toTitle: String {
        switch self {
        case .date:
            "영화 관람 날짜"
        case .tag:
            "태그"
        }
    }
}

final class MemoDetailViewController: BaseViewController {
    private let titleTextField: MemoTextField = {
        let tf = MemoTextField(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        tf.placeholder = "제목을 입력하세요."
        tf.font = Constant.Font.regular14
        tf.textColor = .black
        return tf
    }()
    private let contentTextView: MemoTextView = {
        let view = MemoTextView(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        view.textColor = .black
        view.font = Constant.Font.regular13
        view.text = "하이루 이건 placeholder처리 해줘야함"
        return view
    }()
    private let dateButton: MemoBasicButton = MemoBasicButton(title: BasicBtn.date.toTitle)
    private let tagButton: MemoBasicButton = MemoBasicButton(title: BasicBtn.tag.toTitle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBtn()
    }
    override func configureHierarchy() {
        [titleTextField, contentTextView, dateButton, tagButton]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalToSuperview().inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(100)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
        tagButton.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
    }
    
    private func configureBtn() {
        dateButton.addTarget(self, action: #selector(dateBtnTapped), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(tagBtnTapped), for: .touchUpInside)
    }
    
    @objc private func dateBtnTapped() {
        print(#function) // - datepicker
    }
    @objc private func tagBtnTapped() {
        print(#function) // - textfield
    }
    
}
