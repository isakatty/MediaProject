//
//  MemoDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

final class MemoDetailViewController: BaseViewController {
    var viewModel: MemoDetailViewModel
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
    private let removeBtn = {
        let btn = UIButton()
        btn.setTitle("삭제", for: .normal)
        btn.backgroundColor = .yellow
        return btn
    }()
    
    init(viewModel: MemoDetailViewModel, viewTitle: String) {
        self.viewModel = viewModel
        
        super.init(viewTitle: viewTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBtn()
        bindData()
        configureNavigationRightBar(action: #selector(saveBtnTapped))
        // navigation back btn 정의 필요함
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        viewModel.outputMovieMemo.onNext { [weak self] movieMemo in
            guard let self else { return }
            
            if movieMemo != nil {
                // view에 보여질 데이터
                guard let movieMemo, let movie = movieMemo.movie.first else {
                    print("movieMemo.movie.first 없는 문제?", #function)
                    return
                }
                self.configureMemo(
                    poster: movie.poster,
                    title: movieMemo.title,
                    content: movieMemo.content,
                    date: movieMemo.watchedDate,
                    tag: movieMemo.tag?.addHashTag()
                )
            }
        }
        viewModel.outputSearchMovie.bind { [weak self] _ in
            guard let self else { return }
            let vc = SearchViewController(searchFlow: .memoToSearch)
            vc.searchViewModel.delegate = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.selectedMovie.bind { [weak self] movie in
            guard let self, let movie else { return }
            posterImgView.configureUI(posterPath: movie.poster)
        }
        viewModel.outputSelectedTagBtn.bind { [weak self] _ in
            guard let self else { return }
            let vc = MemoTagViewController(
                tagViewModel: MemoTagViewModel(
                    tagString: viewModel.outputMovieMemo.value?.tag
                ),
                viewTitle: "태그"
            )
            vc.tagViewModel.delegate = self.viewModel
            let navi = UINavigationController(rootViewController: vc)
            present(navi, animated: true)
        }
        viewModel.outputSelectedDateBtn.bind { [weak self] _ in
            guard let self else { return }
            let vc = MemoDateViewController(
                dateViewModel: MemoDateViewModel(
                    date: viewModel.outputMovieMemo.value?.watchedDate
                ),
                viewTitle: "영화 관람 날짜"
            )
            vc.dateViewModel.delegate = self.viewModel
            let navi = UINavigationController(rootViewController: vc)
            present(navi, animated: true)
        }
        viewModel.outputTagString.bind { [weak self] tag in
            guard let self else { return }
            self.tagButton.configureUI(detail: tag?.addHashTag())
        }
        viewModel.outputDate.bind { [weak self] date in
            guard let self else { return }
            if let date {
                self.dateButton.configureUI(detail: DateFormatterManager.shared.changedDateFormat(date1: date))
            }
        }
        viewModel.outputDismissTrigger.bind { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        viewModel.outputAlert.bind { [weak self] _ in
            guard let self else { return }
            self.showToast(message: "영화를 선택하고 메모의 제목을 작성해주세요.")
        }
        viewModel.outputMovieWithMemo.bind { [weak self] (movie, memo) in
            guard let self else { return }
            MovieRepository.shared.removeMemoWithMovie(movie: movie, memo: memo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [posterImgView, titleTextField, contentTextView, dateButton, tagButton, removeBtn]
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
            make.height.equalTo(posterImgView.snp.width).multipliedBy(1.50)
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
//            make.bottom.equalTo(contentView.snp.bottom).inset(Constant.Spacing.twelve.toCGFloat)
        }
        removeBtn.snp.makeConstraints { make in
            make.top.equalTo(tagButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constant.Spacing.twelve.toCGFloat)
        }
    }
    
    private func configureBtn() {
        posterImgView.clearBtn.addTarget(self, action: #selector(addMovieClearBtnTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateBtnTapped), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(tagBtnTapped), for: .touchUpInside)
        removeBtn.addTarget(self, action: #selector(removeBtnTapped), for: .touchUpInside)
    }
    private func configureMemo(poster: String, title: String, content: String?, date: Date?, tag: String?) {
        if date != nil, let date = date {
            dateButton.configureUI(detail: DateFormatterManager.shared.changedDateFormat(date1: date))
        }
        posterImgView.configureUI(posterPath: poster)
        titleTextField.text = title
        contentTextView.text = content
        tagButton.configureUI(detail: tag)
    }
    
    @objc private func dateBtnTapped() {
        print(#function) // - datepicker
        viewModel.inputDateTrigger.value = ()
    }
    @objc private func tagBtnTapped() {
        print(#function) // - textfield
        viewModel.inputTagTrigger.value = ()
    }
    @objc private func addMovieClearBtnTapped() {
        print(#function) // 영화 정보 추가하는 투명 버튼
        viewModel.inputSearchMovieTrigger.value = ()
    }
    @objc private func saveBtnTapped() {
        guard let titleText = titleTextField.text else { return }
        if titleText.isEmpty {
            viewModel.inputAlertTrigger.value = ()
        } else {
            if let selectedMovie = viewModel.selectedMovie.value {
                saveMovieMemo(title: titleText, movie: selectedMovie)
            } else if viewModel.outputMovieMemo.value?.movie.first != nil {
                saveMovieMemo(title: titleText, movie: viewModel.outputMovieMemo.value?.movie.first)
            } else {
                viewModel.inputAlertTrigger.value = ()
            }
        }
    }
    @objc private func removeBtnTapped() {
        viewModel.inputRemoveTrigger.value = ()
    }
    
    private func createMemo(title: String) -> MovieMemo {
        let reSave = MovieMemo(
            title: title,
            content: contentTextView.text == contentPlaceholder ? nil : contentTextView.text,
            tag: viewModel.outputTagString.value == nil ? viewModel.outputMovieMemo.value?.tag : viewModel.outputTagString.value,
            watchedDate: viewModel.outputDate.value == nil ? viewModel.outputMovieMemo.value?.watchedDate : viewModel.outputDate.value
        )
        return reSave
    }
    private func saveMovieMemo(title: String, movie: Movie?) {
        let reSave = createMemo(title: title)
        if let movieMemo = viewModel.outputMovieMemo.value {
            reSave.id = movieMemo.id
        }
        viewModel.inputSaveTrigger.value = (reSave, movie)
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
