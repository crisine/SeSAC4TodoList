//
//  AddListViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import Foundation
import UIKit
import RealmSwift

enum ColorList: CaseIterable {
    case red, orange, yellow, green, blue, purple, brown
    
    var color: UIColor {
        switch self {
        case .red:
            return .systemRed
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        case .purple:
            return .systemPurple
        case .brown:
            return .systemBrown
        }
    }
}

class AddListViewController: BaseViewController {
    
    private let addListTableView = UITableView()
    private let colorList = ColorList.allCases
    private let repository = TodoCategoryRepository()
    
    private var isListNameTextFieldEmpty = true
    private var listName: String?
    private var selectedColorIndex: Int? {
        didSet {
            addListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "새로운 목록"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonItemTapped))
        
        let addListBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didAddListBarButtonItemTapped))
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = addListBarButtonItem
        
        addListTableView.register(AddListNameTableViewCell.self, forCellReuseIdentifier: AddListNameTableViewCell.identifier)
        addListTableView.register(AddListSelectColorTableViewCell.self, forCellReuseIdentifier: AddListSelectColorTableViewCell.identifier)
        
        addListTableView.delegate = self
        addListTableView.dataSource = self
    }
    
    override func configureHierarchy() {
        view.addSubview(addListTableView)
    }
    
    override func configureConstraints() {
        addListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = SeSACColor.veryDarkGray.color
        
        addListTableView.backgroundColor = SeSACColor.veryDarkGray.color
        addListTableView.isScrollEnabled = false
    }
    
    @objc func didCancelBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didAddListBarButtonItemTapped() {
        
        if !isListNameTextFieldEmpty && listName != nil {
            
            let data = TodoCategory()
            
            data.name = listName!
            data.regDate = Date()
            data.color = selectedColorIndex
            
            repository.add(item: data)
            
            dismiss(animated: true)
        } else {
            showToast(message: "목록 이름은 필수로 입력해야 합니다.")
        }
    }
}

extension AddListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddListNameTableViewCell.identifier, for: indexPath) as! AddListNameTableViewCell
            
            if let selectedColorIndex {
                let color = colorList[selectedColorIndex].color
                cell.listIconImageBackView.backgroundColor = color
                cell.listNameTextField.textColor = color
            }
            
            cell.listNameTextField.delegate = self
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddListSelectColorTableViewCell.identifier, for: indexPath) as! AddListSelectColorTableViewCell
            
            cell.selectColorCollectionView.dataSource = self
            cell.selectColorCollectionView.delegate = self
            
            cell.selectColorCollectionView.register(AddListSelectColorCollectionViewCell.self, forCellWithReuseIdentifier: AddListSelectColorCollectionViewCell.identifier)
            
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension AddListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddListSelectColorCollectionViewCell.identifier, for: indexPath) as! AddListSelectColorCollectionViewCell
        let index = indexPath.row
        
        cell.colorView.backgroundColor = colorList[index].color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        selectedColorIndex = index
    }
    
    private func configureCellAsSelected(sender: AddListSelectColorCollectionViewCell) {
        sender.colorView.layer.borderColor = UIColor.gray.cgColor
        sender.colorView.layer.borderWidth = 3
    }
}

extension AddListViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            isListNameTextFieldEmpty = false
        } else {
            isListNameTextFieldEmpty = true
        }
        
        listName = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
