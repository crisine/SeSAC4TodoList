//
//  CategoryViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit

final class CategoryViewController: BaseViewController {

    private let titleLabel = UILabel()
    
    private let todoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())

    private let todoTypeList = TodoType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        todoCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
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
        titleLabel.text = "전체"
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
        // TODO: collectionViewCell 정의 필요
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let index = indexPath.row
        
//        cell.iconImageView.image = todoTypeList[index].image
        cell.iconImageView.backgroundColor = todoTypeList[index].backgroundColor
        cell.categoryLabel.text = todoTypeList[index].rawValue
        cell.countLabel.text = "0"
        
        return cell
    }
    
}
