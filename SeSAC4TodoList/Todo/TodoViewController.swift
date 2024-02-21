//
//  TodoViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit
import RealmSwift

class TodoViewController: BaseViewController {

    let repository = TodoRepository()
    let todoTableView = UITableView()
    var viewType: TodoType?
    var category: TodoCategory?
    
    var allTodoList: Results<TodoModel>!
    var filteredTodoList: Results<TodoModel>! {
        didSet {
            todoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.tableHeaderView = UIView()
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        
        
        let orderByDueDate = UIAction(title: "마감일 순으로 보기", image: UIImage(systemName: "calendar.badge.clock")) { _ in
            
            self.filteredTodoList = self.allTodoList.sorted(byKeyPath: "dueDate", ascending: true)
        }
        
        let orderByTitle = UIAction(title: "제목 순으로 보기", image: UIImage(systemName: "text.line.first.and.arrowtriangle.forward")) { _ in
            
            self.filteredTodoList = self.allTodoList.sorted(byKeyPath: "title", ascending: true)
        }
        
        let displayLowPriorityOnly = UIAction(title: "우선순위 낮음만 보기", image: UIImage(systemName: "exclamationmark")) { _ in
            
            let predicate = NSPredicate(format: "priority == 0")
            self.filteredTodoList = self.allTodoList.filter(predicate)
        }
        
        let rightBarButtonItem = UIBarButtonItem(title: "정렬 순서", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: UIMenu(title: "정렬 순서", children: [orderByDueDate, orderByTitle, displayLowPriorityOnly]))
        
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
        
        allTodoList = repository.fetch()
        
        switch viewType {
        case .today:
            let start = Calendar.current.startOfDay(for: Date())
            let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
            
            let predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@ && isCompleted != TRUE", start as NSDate, end as NSDate)
            allTodoList = allTodoList.filter(predicate)
            
        case .scheduled:
            let scheduledDate = Calendar.current.startOfDay(for: Date())
            let predicate = NSPredicate(format: "dueDate > %@ && isCompleted != TRUE", scheduledDate as NSDate)
            
            allTodoList = allTodoList.filter(predicate)
            
        case .all:
            print("")

        case .flagged:
            let predicate = NSPredicate(format: "isFlagged == TRUE && isCompleted != TRUE")
            allTodoList = allTodoList.filter(predicate)
            
        case .completed:
            let predicate = NSPredicate(format: "isCompleted == TRUE")
            allTodoList = allTodoList.filter(predicate)
            
        case .category:
            // TODO: 이 부분의 코드가 나중엔 전체를 떼올 때 사용되어야 한다.
            // 지금 못 쓰는 이유는 기본적으로 목록이 지정되지 않은 경우 Default 목록으로 가야 하는데 그게 없기 때문
            allTodoList = repository.fetch().where { todoModel in
                todoModel.main.name == category!.name
            }
        }
        
        filteredTodoList = allTodoList
        
        todoTableView.reloadData()
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
        
        let cell = todoTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TodoTableViewCell
        
        let todo = filteredTodoList[index]
        
        if todo.isCompleted == false {
            cell?.circleButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            cell?.circleButton.tintColor = .systemBlue
        } else if todo.isCompleted == true {
            cell?.circleButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell?.circleButton.tintColor = .gray
        }
        
        todo.isCompleted.toggle()
        repository.update(item: todo)
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
        
        if let savedImage = loadImageToDocument(filename: "\(todo.id)") {
            cell.pickedImageView.image = savedImage
            
            cell.pickedImageView.snp.remakeConstraints { make in
                print("이미지 컨스트레인트 재생성중")
                if todo.dueDate != nil {
                    make.top.equalTo(cell.dateLabel.snp.bottom).inset(4)
                } else if todo.tag != nil {
                    make.top.equalTo(cell.tagLabel.snp.bottom).inset(4)
                } else if todo.memo != nil {
                    make.top.equalTo(cell.memoTextLabel.snp.bottom).inset(4)
                } else {
                    make.top.equalTo(cell.titleLabel.snp.bottom).inset(4)
                }
                
                make.leading.equalTo(cell.contentView.safeAreaLayoutGuide).offset(32)
                make.trailing.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
                make.height.equalTo(80)
                make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide).inset(4)
            }
        }
        
        
        configureTodoTableViewCell(cell, index)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let modify = UIContextualAction(style: .normal, title: "수정") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let index = indexPath.row
            let todo = self.filteredTodoList[index]
            let vc = AddTodoViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            vc.titleString = todo.title
            vc.memoString = todo.memo
            
            vc.selectedDate = todo.dueDate
            vc.selectedTag = todo.tag
            vc.selectedPriority = todo.priority
            vc.modifyMode = true
            
            vc.modifyTodo = todo
            vc.pickedImage = self.loadImageToDocument(filename: "\(todo.id)")
            
            self.present(nav, animated: true)
            
            success(true)
        }
        modify.backgroundColor = .systemYellow
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let todo = self.filteredTodoList[indexPath.row]
            
            self.repository.delete(item: todo)
            
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
                    
                    if todo.isFlagged != nil {
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
