//
//  MemoDateViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import UIKit

final class MemoDateViewController: BaseViewController {
    var dateViewModel: MemoDateViewModel
    
    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.preferredDatePickerStyle = .inline
        date.locale = Locale(identifier: "ko_KR")
        date.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return date
    }()
    
    init(dateViewModel: MemoDateViewModel, viewTitle: String) {
        self.dateViewModel = dateViewModel
        
        super.init(viewTitle: viewTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        configureNavigationLeftBar(action: #selector(customBackTapped))
    }
    
    private func bindData() {
        dateViewModel.inputViewDidLoad.value = ()
        dateViewModel.outputSelectedDate.onNext { [weak self] selectedDate in
            guard let self else { return }
            
            if let selectedDate {
                // 이미 있는 메모에서 넘어올 때 datePicker에서 보여질.
                self.datePicker.date = selectedDate
            } else {
                // 선택된 날짜 없으면 오늘자 기준
                self.datePicker.date = Date()
            }
        }
        dateViewModel.outputBackBtnAction.bind { [weak self] _ in
            guard let self else { return }
            
            dateViewModel.delegate?.passDate(date: self.dateViewModel.outputSelectedDate.value)
            dismiss(animated: true)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(datePicker.snp.width).multipliedBy(1.2)
        }
    }
    @objc private func dateChanged(_ datePicker: UIDatePicker) {
        dateViewModel.inputDatePickerTrigger.value = datePicker.date
    }
    @objc private func customBackTapped() {
        print(#function)
        // backBtnTapped 되었을 때, 
        dateViewModel.inputBackBtnTrigger.value = ()
    }
}
