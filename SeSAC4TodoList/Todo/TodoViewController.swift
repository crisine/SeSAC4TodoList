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
    var allToDoList: [TodoModel] = [] {
        didSet {
            todoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        allToDoList = realm.objects(TodoModel.self).map { $0 }
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
        return allToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let index = indexPath.row
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy. MM. dd."
        
        cell.titleLabel.text = allToDoList[index].title
        
        if let dueDate = allToDoList[index].dueDate {
            // TODO: dueDate가 금일이라면 '오늘' 로 표시 후, 시간을 표시
            cell.dateLabel.text = dateformatter.string(from: dueDate)
        }
        
        return cell
    }
    
}
