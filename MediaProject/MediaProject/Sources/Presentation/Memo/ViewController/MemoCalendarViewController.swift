//
//  MemoCalendarViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

import FSCalendar

final class MemoCalendarViewController: BaseViewController {
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
        setEvents()
//        calendarLabel.configureUI(
//            movie: "디센던츠: 레드의 반항",
//            memoTitle: "오늘은 이상한 영화를 보앗다",
//            wroteDate: Date(),
//            tag: "#수윤"
//        )
        configureBtn()
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
    // TODO: 이벤트 추가 하는 형태 - Date형태 맞춰서 calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) 에서 관리
    private func setEvents() {
        let dfMatter = DateFormatter()
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyy-MM-dd"
        
        // events
        let myFirstEvent = dfMatter.date(from: "2024-07-11")
        let mySecondEvent = dfMatter.date(from: "2024-07-01")
        
        events = [myFirstEvent!, mySecondEvent!]
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
        let vc = MemoDetailViewController(viewTitle: ViewCase.memo.viewTitle)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MemoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        print(date, "선택됨")
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
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
}
