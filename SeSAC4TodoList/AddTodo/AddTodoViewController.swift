//
//  AddTodoViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit
import RealmSwift

enum AddTodoCategory: String, CaseIterable {
    case duedate = "마감일"
    case tag = "태그"
    case priority = "우선순위"
}

protocol PassDataDelegate {
    func priorityReceived(priority: Int?)
}

class AddTodoViewController: BaseViewController, PassDataDelegate {

    let addTodoTableView = UITableView()
    let todoCategoryList = AddTodoCategory.allCases
    lazy var todoHeaderView = AddTodoTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 160))
    
    func priorityReceived(priority: Int?) {
        selectedPriority = priority
    }
    
    var titleString: String?
    var memoString: String?
    var modifyMode: Bool = false
    var modifyTodo: TodoModel?
    
    var selectedDate: Date? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    var selectedTag: String? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    var selectedPriority: Int? {
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
        
        let navigationTitleString = modifyMode == true ? "할 일 수정" : "새로운 할 일"
        
        navigationItem.title = navigationTitleString
        
        let cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonItemTapped))
        
        let doneBarButtonTitle = modifyMode == true ? "수정" : "추가"
        
        let doneBarButtonItem = UIBarButtonItem(title: doneBarButtonTitle, style: .done, target: self, action: #selector(didDoneBarButtonItemTapped))
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    @objc func didCancelBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didDoneBarButtonItemTapped() {
        
        guard todoHeaderView.titleTextField.text != "" else {
            showToast(message: "제목은 필수 입력 사항입니다.")
            return
        }
        
        showAlert(title: "새 할일", message: "저장하시겠습니까?", okTitle: "저장") {
            // TODO: DB를 통해 저장 등...
            
            let realm = try! Realm()
            print(realm.configuration.fileURL)
            
            if let headerView = self.addTodoTableView.tableHeaderView as? AddTodoTableHeaderView {
                
                headerView.memoTextView.delegate = self
                
                guard let title = headerView.titleTextField.text else { return }
                
                let memo = headerView.memoTextView.text == "메모" ? nil : headerView.memoTextView.text
                
                // TODO: 선택된 중요도 넣기
                let data = TodoModel(title: title, memo: memo, dueDate: self.selectedDate, tag: self.selectedTag, priority: self.selectedPriority)
                
                try! realm.write {
                    if self.modifyMode == true {
                        // TODO: 수정 뷰에서는 완료 여부를 수정할 수 있게 하면 여기서 self.modifyTodo.isCompleted가 아니라, self.isCompleted 이렇게 접근해야 한다.
                        realm.create(TodoModel.self, value: ["id": self.modifyTodo?.id, "title": title, "memo": memo, "dueDate": self.selectedDate, "tag": self.selectedTag, "priority": self.selectedPriority, "isCompleted": self.modifyTodo?.isCompleted, "isFlagged": self.modifyTodo?.isFlagged], update: .modified)
                    } else {
                        realm.add(data)
                    }
                    print("Realm Create Called")
                }
            }
            
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
        addTodoTableView.tableHeaderView = todoHeaderView
        
        todoHeaderView.memoTextView.delegate = self
        
        if let titleString {
            todoHeaderView.titleTextField.text = titleString
        }
        
        if let memoString {
            todoHeaderView.memoTextView.text = memoString
        }
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
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd."
            
            if let selectedDate {
                cell.subtitleLabel.text = formatter.string(from: selectedDate)
            }
        case .tag:
            cell.subtitleLabel.text = selectedTag
        case .priority:
            if let priorityValue = selectedPriority {
                cell.subtitleLabel.text = Priority(rawValue: priorityValue)?.string
            } else {
                cell.subtitleLabel.text = nil
            }
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
            let vc = PriorityViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모" {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "메모"
            textView.textColor = .gray
        }
    }
    
}
