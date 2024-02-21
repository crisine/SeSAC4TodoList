//
//  AddListFromExistViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit
import SnapKit
import RealmSwift

class AddListFromExistViewController: BaseViewController {
    
    private let categoryListTableView = UITableView()
    private var categoryList: Results<TodoCategory>!
    private let repository = TodoCategoryRepository()
    private let colorList = ColorList.allCases
    
    private var selectedCategory: TodoCategory?
    var categorySpace: ((TodoCategory) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
        categoryListTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        categoryList = repository.fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let selectedCategory {
            categorySpace?(selectedCategory)
        }
    }
    
    override func configureHierarchy() {
        [categoryListTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        categoryListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = SeSACColor.veryDarkGray.color
        categoryListTableView.backgroundColor = SeSACColor.veryDarkGray.color
    }
}

extension AddListFromExistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        let data = categoryList[indexPath.row]
        
        if let colorIndex = data.color {
            cell.iconImageBackView.backgroundColor = colorList[colorIndex].color
        }
        
        cell.titleLabel.text = data.name
        cell.modifyButton.imageView?.image = nil // 뷰 재활용..
        cell.selectionStyle = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row]
    }
}
