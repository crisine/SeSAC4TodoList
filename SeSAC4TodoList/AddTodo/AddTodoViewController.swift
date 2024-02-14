//
//  AddTodoViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit

enum AddTodoCategory: String, CaseIterable {
    case duedate = "마감일"
    case tag = "태그"
    case priority = "우선순위"
}

class AddTodoViewController: BaseViewController {

    let addTodoTableView = UITableView()
    let todoCategoryList = AddTodoCategory.allCases
    
    var selectedDate: String? {
        didSet {
            addTodoTableView.reloadData()
            print("tableview Reload")
        }
    }
    
    var selectedTag: String? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()

        addTodoTableView.delegate = self
        addTodoTableView.dataSource = self
        addTodoTableView.register(AddTodoTableViewCell.self, forCellReuseIdentifier: "AddTodoTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedNotificationFromTagViewController), name: NSNotification.Name("tagNotification"), object: nil)
    }
    
    @objc func recievedNotificationFromTagViewController(notification: NSNotification) {
        if let value = notification.userInfo?["tag"] as? String {
            selectedTag = value
        }
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "새로운 할 일"
        let cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonItemTapped))
        let doneBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(didDoneBarButtonItemTapped))
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    @objc func didCancelBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didDoneBarButtonItemTapped() {
        showAlert(title: "새 할일", message: "저장하시겠습니까?", okTitle: "저장") {
            // TODO: DB를 통해 저장 등...
            
            self.dismiss(animated: true)
        }
    }

    override func configureHierarchy() {
        view.addSubview(addTodoTableView)
    }
    
    override func configureConstraints() {
        addTodoTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        addTodoTableView.backgroundColor = SeSACColor.veryDarkGray.color
        addTodoTableView.isScrollEnabled = false
        addTodoTableView.separatorStyle = .none
        addTodoTableView.tableHeaderView = AddTodoTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 160))
    }

}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoTableViewCell", for: indexPath) as! AddTodoTableViewCell
        let index = indexPath.row
        
        cell.titleLabel.text = todoCategoryList[index].rawValue
        
        switch todoCategoryList[index] {
        case .duedate:
            cell.subtitleLabel.text = selectedDate
        case .tag:
            cell.subtitleLabel.text = selectedTag
        case .priority:
            cell.subtitleLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedRowType = todoCategoryList[index]
        
        switch selectedRowType {
        case .duedate:
            let vc = DueDateViewController()
            
            vc.dateSpace = { date in
                print("dateSpace 전달됨")
                print("날짜 뷰에서 \(date) 가 선택되었습니다")
                self.selectedDate = date
            }
            
            navigationController?.pushViewController(vc, animated: true)
        case .tag:
            let vc = TagViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .priority:
            print("우선순위 세그먼트 달린 뷰로 이동")
        }
    }
    
}
