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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()

        addTodoTableView.delegate = self
        addTodoTableView.dataSource = self
        addTodoTableView.register(AddTodoTableViewCell.self, forCellReuseIdentifier: "AddTodoTableViewCell")
        
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
        
    }
    
    @objc func didDoneBarButtonItemTapped() {
        
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
        
        // TODO: 해당하는 VC에 따라서 closure를 통해 값 전달받기
        cell.subtitleLabel.text = ""
        
        return cell
    }
    
}
