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

    private let todoTypeList = TodoType.allCases
    
    var todoList: Results<TodoModel>!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        todoCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        navigationController?.isToolbarHidden = false
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        todoList = realm.objects(TodoModel.self)
    }
    
    @objc func didTodoAddButtonTapped() {
        let vc = UINavigationController(rootViewController: AddTodoViewController())
        present(vc, animated: true)
    }
    
    @objc func didListAddButtonTapped() {
        let vc = UINavigationController(rootViewController: AddListViewController())
        present(vc, animated: true)
    }
    
    override func configureHierarchy() {
        [titleLabel, todoCollectionView].forEach { subView in
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
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        todoCollectionView.backgroundColor = .black
        
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
        
        return todoTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let index = indexPath.row
        
        // TODO: 심볼 이미지의 크기를 조정할 수 있게 할 것.
        // MARK: 현재 문제 1. 시스템 이미지 크기에 따라 높이가 제각각 2. size를 40x40으로 설정했음에도 아이콘에 따라 height가 들쭉날쭉해짐
        cell.iconImageView.image = todoTypeList[index].image
        cell.iconImageView.backgroundColor = todoTypeList[index].backgroundColor
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
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
