//
//  MemoCalendarViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

import FSCalendar

final class MemoCalendarViewController: BaseViewController {
    private let viewModel = MemoCalendarViewModel()
    
    private var events = [Date]()
    private lazy var fsCalendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    private let calendarLabel: CalendarLabelView = CalendarLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCalendar()
        configureBtn()
        bindData()
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        viewModel.outputMovieMemo.onNext { [weak self] movieMemo in
            guard let self = self else { return }
//            print(movieMemo)
            if movieMemo != nil {
                guard let movieMemo = movieMemo,
                      let movie = movieMemo.movie.first else { return }
                self.calendarLabel.configureUI(
                    posterPath: movie.poster,
                    movie: movie.title,
                    memoTitle: movieMemo.title,
                    wroteDate: movieMemo.regDate,
                    tag: movieMemo.tag
                )
            } else {
                self.calendarLabel.configureNoMemo()
            }
        }
        viewModel.outputMemoDetail.bind { [weak self] _ in
            guard let self else { return }
            
            // 메모 유무에 따라 VC, DetailVM이 받을 데이터가 다를 듯.
            let vc = MemoDetailViewController(viewTitle: ViewCase.memo.viewTitle)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        [fsCalendar, calendarLabel]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        fsCalendar.snp.makeConstraints { make in
            make.top.width.equalTo(safeArea).inset(Constant.Spacing.twelve.toCGFloat)
            make.centerX.equalTo(safeArea)
            make.height.equalTo(fsCalendar.snp.width)
        }
        calendarLabel.snp.makeConstraints { make in
            make.top.equalTo(fsCalendar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(Constant.Spacing.twelve.toCGFloat)
            make.height.equalTo(120)
        }
    }
    private func configCalendar() {
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.weekdayTextColor = .black
        fsCalendar.appearance.selectionColor = .systemGreen // 선택되었을 때, 배경
        fsCalendar.appearance.todayColor = .systemGreen
        fsCalendar.appearance.titleDefaultColor = .black
        fsCalendar.appearance.titleSelectionColor = .black
        fsCalendar.appearance.titleTodayColor = .black
        fsCalendar.appearance.eventDefaultColor = UIColor.black
        fsCalendar.appearance.eventSelectionColor = UIColor.black
        fsCalendar.appearance.titleWeekendColor = UIColor.red
    }
    private func configureBtn() {
        calendarLabel.clearBtn.addTarget(self, action: #selector(clearBtnTapped), for: .touchUpInside)
    }
    @objc func clearBtnTapped() {
        viewModel.movieBtnTrigger.value = ()
    }
}
extension MemoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        viewModel.inputDateTrigger.value = date
        calendar.appearance.todayColor = .clear
    }
    func calendar(
        _ calendar: FSCalendar,
        didDeselect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        print(date, "선택해제됨")
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let changedDate = DateFormatterManager.shared.changedDateFormat(date1: date)
        let memoTest = viewModel.outputDates.value.map { dates in
            dates.map { date in
                DateFormatterManager.shared.changedDateFormat(date1: date)
            }
        }
        guard let memoTest else { return 0 }
        if memoTest.contains(changedDate) {
            return 1
        } else {
            return 0
        }
    }
}
