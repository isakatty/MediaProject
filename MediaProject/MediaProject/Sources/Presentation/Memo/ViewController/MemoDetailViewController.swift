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
    private let contentPlaceholder: String = "어떤 내용의 영화를 누구와 봤는지, 어땠는지 남겨주세요."
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let contentView = UIView()
    private let posterImgView = MoviePosterView()
    private let titleTextField: MemoTextField = {
        let tf = MemoTextField(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
        tf.placeholder = "제목을 입력하세요."
        tf.font = Constant.Font.regular14
        tf.textColor = .black
        return tf
    }()
    private lazy var contentTextView: MemoTextView = {
        let view = MemoTextView(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        view.textColor = .darkGray
        view.font = Constant.Font.regular13
        view.text = contentPlaceholder
        view.delegate = self
        return view
    }()
    private let dateButton: MemoBasicButton = MemoBasicButton(title: BasicBtn.date.toTitle)
    private let tagButton: MemoBasicButton = MemoBasicButton(title: BasicBtn.tag.toTitle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBtn()
    }
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [posterImgView, titleTextField, contentTextView, dateButton, tagButton]
            .forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalToSuperview()
        }
        configureContentView()
    }
    private func configureContentView() {
        posterImgView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(24)
            make.width.equalTo(posterImgView.snp.height).multipliedBy(0.67)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(posterImgView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(150)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
        }
        tagButton.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constant.Spacing.twelve.toCGFloat)
        }
    }
    
    private func configureBtn() {
        posterImgView.clearBtn.addTarget(self, action: #selector(addMovieClearBtnTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateBtnTapped), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(tagBtnTapped), for: .touchUpInside)
    }
    
    @objc private func dateBtnTapped() {
        print(#function) // - datepicker
    }
    @objc private func tagBtnTapped() {
        print(#function) // - textfield
    }
    @objc private func addMovieClearBtnTapped() {
        print(#function) // 영화 정보 추가하는 투명 버튼
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentPlaceholder
            textView.textColor = .lightGray
        }
    }
}