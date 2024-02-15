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
    var allTodoList: [TodoModel] = [] {
        didSet {
            filteredTodoList = allTodoList
        }
    }
    var filteredTodoList: [TodoModel] = [] {
        didSet {
            todoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didSortOptionButtonTapped))
        
        let orderByDueDate = UIAction(title: "마감일 순으로 보기", image: UIImage(systemName: "calendar.badge.clock")) { _ in
            
            // TODO: Filter 방식이 이상한지 날짜가 없던 항목에도 날짜가 붙는 문제 발생
            self.filteredTodoList = self.allTodoList.sorted {
                $0.dueDate ?? Date(timeIntervalSinceReferenceDate: TimeInterval.greatestFiniteMagnitude) < $1.dueDate ?? Date(timeIntervalSinceReferenceDate: TimeInterval.greatestFiniteMagnitude)
            }
        }
        
        let orderByTitle = UIAction(title: "제목 순으로 보기", image: UIImage(systemName: "text.line.first.and.arrowtriangle.forward")) { _ in
            
            self.filteredTodoList = self.allTodoList.sorted {
                $0.title < $1.title
            }
        }
        let displayLowPriorityOnly = UIAction(title: "우선순위 낮음만 보기", image: UIImage(systemName: "exclamationmark")) { _ in
            
            self.filteredTodoList = self.allTodoList.filter {
                $0.priority == 0
            }
        }
        
        rightBarButtonItem.menu = UIMenu(title: "정렬 순서",
                                         image: nil,
                                         identifier: nil,
                                         options: .displayInline,
                                         children: [orderByDueDate, orderByTitle, displayLowPriorityOnly])
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func didSortOptionButtonTapped() {
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        allTodoList = realm.objects(TodoModel.self).map { $0 }
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
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let index = indexPath.row
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy. MM. dd."
        
        cell.titleLabel.text = filteredTodoList[index].title
        
        if let dueDate = filteredTodoList[index].dueDate {
            // TODO: dueDate가 금일이라면 '오늘' 로 표시 후, 시간을 표시
            cell.dateLabel.text = dateformatter.string(from: dueDate)
        }
        
        return cell
    }
    
}
