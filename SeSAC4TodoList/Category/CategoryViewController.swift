//
//  CategoryViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit
import RealmSwift

final class CategoryViewController: BaseViewController {

    private let titleLabel = UILabel()
    private let todoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    private let categoryTableView = UITableView()

    private let todoTypeList = TodoType.allCases
    private let colorList = ColorList.allCases
    
    private var todoList: Results<TodoModel>!
    private var categoryList: Results<TodoCategory>! {
        didSet {
            categoryTableView.reloadData()
        }
    }

    private let todoRepository = TodoRepository()
    private let todoCategoryRepository = TodoCategoryRepository()
    
    override func viewWillAppear(_ animated: Bool) {
        todoList = todoRepository.fetch()
        categoryList = todoCategoryRepository.fetch()
        todoCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        todoCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        todoCollectionView.isScrollEnabled = false
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        categoryTableView.isScrollEnabled = false
        
        navigationController?.isToolbarHidden = false
        configureToolbarItems()
    }
    
    private func configureToolbarItems() {
        let customizedTodoAddButton = UIButton(type: .system)
    
        customizedTodoAddButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        customizedTodoAddButton.setTitle(" 새로운 할 일", for: .normal)
        customizedTodoAddButton.addTarget(self, action: #selector(didTodoAddButtonTapped), for: .touchUpInside)
        customizedTodoAddButton.sizeToFit()
        
        let todoAddButton = UIBarButtonItem(customView: customizedTodoAddButton)
        
        let listAddButton = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(didListAddButtonTapped))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [todoAddButton, flexibleSpace, listAddButton]
    }
    
    @objc func didTodoAddButtonTapped() {
        let vc = UINavigationController(rootViewController: AddTodoViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func didListAddButtonTapped() {
        let vc = UINavigationController(rootViewController: AddListViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func configureHierarchy() {
        [titleLabel, todoCollectionView, categoryTableView].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    override func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        todoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(UIScreen.main.bounds.width / 1.5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(todoCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
    }
    
    override func configureView() {
        todoCollectionView.backgroundColor = .black
        categoryTableView.backgroundColor = .black
        
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = .darkGray
        titleLabel.text = "할 일 목록"
    }
    
    static private func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 8, height: UIScreen.main.bounds.height / 10 - 8)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 4
                
        return layout
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return todoTypeList.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let index = indexPath.row
        
        // TODO: 심볼 이미지의 크기를 조정할 수 있게 할 것.
        // MARK: 현재 문제 1. 시스템 이미지 크기에 따라 높이가 제각각 2. size를 40x40으로 설정했음에도 아이콘에 따라 height가 들쭉날쭉해짐
        cell.iconImageView.image = todoTypeList[index].image
        cell.iconImageBackView.backgroundColor = todoTypeList[index].backgroundColor
        cell.categoryLabel.text = todoTypeList[index].rawValue
        
        switch todoTypeList[index] {
        case .today:
            let start = Calendar.current.startOfDay(for: Date())
            let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
     
            let predicate = NSPredicate(format: "dueDate >= %@ && dueDate < %@ && isCompleted != TRUE", start as NSDate, end as NSDate)
            
            cell.countLabel.text = String(todoList.filter(predicate).count)
        case .scheduled:
            let scheduledDate = Calendar.current.startOfDay(for: Date())
            let predicate = NSPredicate(format: "dueDate > %@ && isCompleted != TRUE", scheduledDate as NSDate)
            
            cell.countLabel.text = String(todoList.filter(predicate).count)
        case .all:
            cell.countLabel.text = String(todoList.count)
        case .flagged:
            let predicate = NSPredicate(format: "isFlagged == TRUE")
            cell.countLabel.text = String(todoList.filter(predicate).count)
        case .completed:
            let predicate = NSPredicate(format: "isCompleted == TRUE")
            cell.countLabel.text = String(todoList.filter(predicate).count)
        default:
            print()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let vc = TodoViewController()
        
        switch todoTypeList[index] {
        case .today:
            vc.viewType = .today
        case .scheduled:
            vc.viewType = .scheduled
        case .all:
            vc.viewType = .all
        case .flagged:
            vc.viewType = .flagged
        case .completed:
            vc.viewType = .completed
        default:
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        cell.subtitleLabel.text = String(data.todo.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: 선택된 category 기준으로 상세 뷰로 이동
        let selectedCategory = categoryList[indexPath.row]
        
        let vc = TodoViewController()
        vc.category = selectedCategory
        vc.viewType = .category
        
        print("selectedCategory name: \(selectedCategory.name)")
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
