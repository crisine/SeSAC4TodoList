//
//  TodoViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit
import RealmSwift

class TodoViewController: BaseViewController {

    let todoTableView = UITableView()
    var viewType: TodoType?
    
    var allTodoList: [TodoModel] = [] {
        didSet {
            filteredTodoList = allTodoList
            todoTableView.reloadData()
        }
    }
    var filteredTodoList: [TodoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.tableHeaderView = UIView()
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didSortOptionButtonTapped))
        
        let orderByDueDate = UIAction(title: "마감일 순으로 보기", image: UIImage(systemName: "calendar.badge.clock")) { _ in
            
            // TODO: Filter 방식이 이상한지 날짜가 없던 항목에도 날짜가 붙는 문제 발생
            self.filteredTodoList = self.allTodoList.sorted {
                $0.dueDate ?? Date(timeIntervalSinceReferenceDate: TimeInterval.greatestFiniteMagnitude) < $1.dueDate ?? Date(timeIntervalSinceReferenceDate: TimeInterval.greatestFiniteMagnitude)
            }
            
            self.todoTableView.reloadData()
        }
        
        let orderByTitle = UIAction(title: "제목 순으로 보기", image: UIImage(systemName: "text.line.first.and.arrowtriangle.forward")) { _ in
            
            self.filteredTodoList = self.allTodoList.sorted {
                $0.title < $1.title
            }
            
            self.todoTableView.reloadData()
        }
        let displayLowPriorityOnly = UIAction(title: "우선순위 낮음만 보기", image: UIImage(systemName: "exclamationmark")) { _ in
            
            self.filteredTodoList = self.allTodoList.filter {
                $0.priority == 0
            }
            
            self.todoTableView.reloadData()
        }
        
        // TODO: 메뉴가 꾹 눌러야 나와서 자칫 동작을 안 하는 메뉴라고 착각할 여지 있음
        rightBarButtonItem.menu = UIMenu(title: "정렬 순서",
                                         children: [orderByDueDate, orderByTitle, displayLowPriorityOnly])
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func didSortOptionButtonTapped() {
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let viewType else {
            showAlert(title: "데이터 없음", message: "할 일 데이터가 없습니다.", okTitle: "확인", handler: {})
            return
        }
        
        let realm = try! Realm()
        
        switch viewType {
        case .today:
            allTodoList = realm.objects(TodoModel.self).filter { $0.dueDate?.compare(Date()) == .orderedSame }
        case .scheduled: 
            allTodoList = realm.objects(TodoModel.self).filter { $0.dueDate?.compare(Date()) == .orderedDescending }
        case .all:
            allTodoList = realm.objects(TodoModel.self).map { $0 }
        case .flagged:
            allTodoList = realm.objects(TodoModel.self).filter { $0.isFlagged == true}
        case .completed:
            allTodoList = realm.objects(TodoModel.self).filter { $0.isCompleted == true }
        }
    }

    override func configureHierarchy() {
        view.addSubview(todoTableView)
    }
    
    override func configureConstraints() {
        todoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .black
        
        todoTableView.backgroundColor = .black
        todoTableView.separatorColor = .gray
        todoTableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
    }
    
    @objc func didTodoCellCircleButtonTapped(sender: UIButton) {
        let index = sender.tag
        
        print("cell : \(index) tapped")
        
        let cell = todoTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoTableViewCell
        
        let todo = filteredTodoList[index]
        
        print("isCompleted : \(todo.isCompleted)")
        
        if todo.isCompleted == false {
            cell?.circleButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            cell?.circleButton.tintColor = .systemBlue
            
            let realm = try! Realm()
            try! realm.write {
                todo.isCompleted = true
            }
        } else if todo.isCompleted == true {
            cell?.circleButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell?.circleButton.tintColor = .gray
            
            let realm = try! Realm()
            try! realm.write {
                todo.isCompleted = false
            }
        }
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let index = indexPath.row
        let todo = filteredTodoList[index]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        cell.titleLabel.text = todo.title
        cell.memoTextLabel.text = todo.memo
        
        if let dueDate = todo.dueDate {
            cell.dateLabel.text = dateFormatter.string(from: dueDate)
        }
        
        if let tag = todo.tag {
            cell.tagLabel.text = "#\(tag)"
        }
        
        cell.circleButton.tag = index
        cell.circleButton.addTarget(self, action: #selector(didTodoCellCircleButtonTapped), for: .touchUpInside)
        
        configureTodoTableViewCell(cell, index)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let modify = UIContextualAction(style: .normal, title: "수정") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            
            
            success(true)
        }
        modify.backgroundColor = .systemYellow
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let index = indexPath.row
            let realm = try! Realm()
            
            do {
                try realm.write {
                    print("realm 삭제 및 로컬 메모리에서 해당 데이터 삭제 시도")
                    realm.delete(self.filteredTodoList.remove(at: index))
                }
            } catch {
                dump(error)
                self.showAlert(title: "에러", message: "할 일을 삭제하지 못했습니다.", okTitle: "확인", handler: { })
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, modify])
    }
    
    private func configureTodoTableViewCell(_ cell: TodoTableViewCell, _ index: Int) {
        print("configuring Tableview Cell Style")
        
        let todo = filteredTodoList[index]
        
        switch todo.isCompleted {
        case true:
            cell.circleButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            cell.circleButton.tintColor = .systemBlue
        case false:
            cell.circleButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.circleButton.tintColor = .systemGray
        }
        
        if todo.memo != nil && todo.dueDate != nil && todo.tag != nil
            && todo.title != "" && todo.isFlagged != nil {
            return
        }
        
        if todo.memo != nil || todo.dueDate != nil || todo.tag != nil {
            
            // memo 먼저 판단 (dueDate, tag는 같은 라인에 배치되어야 함)
            if todo.memo != nil && todo.dueDate == nil && todo.tag == nil {
                cell.dateLabel.snp.removeConstraints()
                cell.tagLabel.snp.removeConstraints()
                
                cell.memoTextLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.titleLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
                // 메모내용 O, 날짜 X, 태그 O
            } else if todo.memo != nil && todo.dueDate == nil && todo.tag != nil {
                cell.dateLabel.snp.removeConstraints()
                cell.tagLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.memoTextLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
                // 메모내용 O, 날짜 O, 태그 X
            } else if todo.memo != nil && todo.dueDate != nil && todo.tag == nil {
                cell.tagLabel.snp.removeConstraints()
                // 메모내용 X, 날짜 X, 태그 O
            } else if todo.memo == nil && todo.dueDate == nil && todo.tag != nil {
                cell.memoTextLabel.snp.removeConstraints()
                cell.dateLabel.snp.removeConstraints()
                cell.tagLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.titleLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
                // 메모내용 X, 날짜 O, 태그 X
            } else if todo.memo == nil && todo.dueDate != nil && todo.tag == nil {
                cell.memoTextLabel.snp.removeConstraints()
                cell.tagLabel.snp.removeConstraints()
                cell.dateLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.titleLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
                // 메모내용 X, 날짜 O, 태그 O
            } else if todo.memo == nil && todo.dueDate != nil && todo.tag != nil {
                cell.memoTextLabel.snp.removeConstraints()
                cell.dateLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.titleLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    make.width.lessThanOrEqualTo(88)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
                cell.tagLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.titleLabel.snp.bottom).offset(4)
                    make.leading.equalTo(cell.dateLabel.snp.trailing).offset(4)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
                }
            }
            
            if let priority = todo.priority {
                switch priority {
                case 0:
                    cell.priorityImageView.image = UIImage(systemName: "exclamationmark")
                case 1:
                    cell.priorityImageView.image = UIImage(systemName: "exclamationmark.2")
                case 2:
                    cell.priorityImageView.image = UIImage(systemName: "exclamationmark.3")
                default:
                    print("정의되지 않은 우선순위라 추후 유지보수 필요")
                }
            } else {
                cell.priorityImageView.snp.removeConstraints()
                cell.titleLabel.snp.remakeConstraints { make in
                    make.top.equalTo(cell.contentView.safeAreaLayoutGuide).offset(4)
                    make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                    
                    if let flagStatus = todo.isFlagged {
                        make.trailing.equalTo(cell.flagImageView.snp.leading).offset(4)
                    } else {
                        cell.flagImageView.snp.removeConstraints()
                        make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    }
                }
            }
            
        } else if let priority = todo.priority {
            cell.dateLabel.snp.removeConstraints()
            
            // priority + title
            switch priority {
            case 0:
                cell.priorityImageView.image = UIImage(systemName: "exclamationmark")
            case 1:
                cell.priorityImageView.image = UIImage(systemName: "exclamationmark.2")
            case 2:
                cell.priorityImageView.image = UIImage(systemName: "exclamationmark.3")
            default:
                print("정의되지 않은 우선순위라 추후 유지보수 필요")
            }
            
            cell.priorityImageView.snp.remakeConstraints { make in
                make.centerY.equalTo(cell.contentView)
                make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                make.size.equalTo(16)
            }
            
            if todo.isFlagged == true {
                cell.flagImageView.image = UIImage(systemName: "flag.fill")
                
                cell.titleLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(cell.priorityImageView)
                    make.leading.equalTo(cell.priorityImageView.snp.trailing).offset(4)
                    make.trailing.equalTo(cell.flagImageView.snp.leading).inset(4)
                }
                
                cell.flagImageView.snp.makeConstraints { make in
                    make.centerY.equalTo(cell.priorityImageView)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                    make.size.equalTo(16)
                }
                
            } else {
                cell.flagImageView.snp.removeConstraints()
                cell.dateLabel.snp.removeConstraints()
                
                cell.titleLabel.snp.remakeConstraints { make in
                    make.centerY.equalTo(cell.priorityImageView)
                    make.leading.equalTo(cell.priorityImageView.snp.trailing).offset(4)
                    make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                }
            }
            
        } else if todo.isFlagged == true {
            // title + flagged
            cell.priorityImageView.snp.removeConstraints()
            
            cell.titleLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(cell.contentView)
                make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                make.trailing.equalTo(cell.flagImageView.snp.leading).inset(4)
            }
            
            cell.flagImageView.snp.remakeConstraints { make in
                make.centerY.equalTo(cell.titleLabel)
                make.size.equalTo(16)
            }
        } else {
            cell.priorityImageView.snp.removeConstraints()
            cell.flagImageView.snp.removeConstraints()
            cell.dateLabel.snp.removeConstraints()
            
            cell.titleLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(cell.contentView)
                make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
            }
        }
    }
}
