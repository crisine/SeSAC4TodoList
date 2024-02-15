//
//  PriorityViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit
import SnapKit

class PriorityViewController: BaseViewController {

    let priorityList = Priority.allCases
    lazy var segmentedControl = UISegmentedControl(items: priorityList.map { $0.rawValue })
    
    var delegate: PassDataDelegate?
    var selectedPriority: Priority?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("PriorityViewDidLoad")
        segmentedControl.addTarget(self, action: #selector(didSegmentValueChanged), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let selectedPriority {
            delegate?.priorityReceived(priority: selectedPriority)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(segmentedControl)
    }

    override func configureConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        view.backgroundColor = SeSACColor.veryDarkGray.color
        
        segmentedControl.backgroundColor = SeSACColor.slightDarkGray.color
    }
    
    @objc func didSegmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        selectedPriority = priorityList[index]
    }
}
