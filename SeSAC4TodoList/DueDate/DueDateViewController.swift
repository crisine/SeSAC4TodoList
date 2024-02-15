//
//  DueDateViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit
import FSCalendar

class DueDateViewController: BaseViewController {

    private let fsCalender : FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        
        calendar.scope = .week
        calendar.scope = .month
        calendar.backgroundColor = SeSACColor.slightDarkGray.color
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 16
        calendar.rowHeight = 200
        
        return calendar
    }()
    var selectedDate: Date?
    var dateSpace: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fsCalender.delegate = self
        fsCalender.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let selectedDate {
            dateSpace?(selectedDate)
        }
    }

    override func configureHierarchy() {
        [fsCalender].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        fsCalender.snp.makeConstraints { make in
             // make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
             // make.height.equalTo(240)
             make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = SeSACColor.veryDarkGray.color
    }
}

extension DueDateViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
    }
}
