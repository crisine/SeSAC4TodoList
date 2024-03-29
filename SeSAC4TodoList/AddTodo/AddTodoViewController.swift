//
//  AddTodoViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit
import RealmSwift

enum AddTodoCategory: String, CaseIterable {
    case duedate = "마감일"
    case tag = "태그"
    case priority = "우선순위"
    case image = "이미지 추가"
    case category = "목록"
}

protocol PassDataDelegate {
    func priorityReceived(priority: Int?)
}

class AddTodoViewController: BaseViewController, PassDataDelegate {

    private let addTodoTableView = UITableView()
    private let todoCategoryList = AddTodoCategory.allCases
    private let colorList = ColorList.allCases
    
    lazy var todoHeaderView = AddTodoTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 160))
    
    func priorityReceived(priority: Int?) {
        selectedPriority = priority
    }
    
    private let repository = TodoRepository()
    
    var titleString: String?
    var memoString: String?
    var modifyMode: Bool = false
    var modifyTodo: TodoModel?
    var pickedImage: UIImage? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    
    var selectedDate: Date? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    var selectedTag: String? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    var selectedPriority: Int? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    var selectedCategory: TodoCategory? {
        didSet {
            addTodoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()

        addTodoTableView.delegate = self
        addTodoTableView.dataSource = self
        addTodoTableView.register(AddTodoTableViewCell.self, forCellReuseIdentifier: "AddTodoTableViewCell")
        addTodoTableView.register(AddTodoImageTableViewCell.self, forCellReuseIdentifier: "AddTodoImageTableViewCell")
        addTodoTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)

        
        NotificationCenter.default.addObserver(self, selector: #selector(recievedNotificationFromTagViewController), name: NSNotification.Name("tagNotification"), object: nil)
    }
    
    @objc func recievedNotificationFromTagViewController(notification: NSNotification) {
        if let value = notification.userInfo?["tag"] as? String {
            selectedTag = value
        }
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navigationTitleString = modifyMode == true ? "할 일 수정" : "새로운 할 일"
        
        navigationItem.title = navigationTitleString
        
        let cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonItemTapped))
        
        let doneBarButtonTitle = modifyMode == true ? "수정" : "추가"
        
        let doneBarButtonItem = UIBarButtonItem(title: doneBarButtonTitle, style: .done, target: self, action: #selector(didDoneBarButtonItemTapped))
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    @objc func didCancelBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func didDoneBarButtonItemTapped() {
        
        guard todoHeaderView.titleTextField.text != "" else {
            showToast(message: "제목은 필수 입력 사항입니다.")
            return
        }
        
        showAlert(title: "새 할일", message: "저장하시겠습니까?", okTitle: "저장") {
            
            if let headerView = self.addTodoTableView.tableHeaderView as? AddTodoTableHeaderView {
                
                headerView.memoTextView.delegate = self
                
                guard let title = headerView.titleTextField.text else { return }
                
                let memo = headerView.memoTextView.text == "메모" ? nil : headerView.memoTextView.text
                
                let data = TodoModel(title: title, memo: memo, dueDate: self.selectedDate, tag: self.selectedTag, priority: self.selectedPriority)
                
                // TODO: 기본 카테고리 ('목록') 이 존재하게되면 선택된 카테고리의 여부를 중시하지 않아도 되니 수정 요함
                if let selectedCategory = self.selectedCategory {
                    self.repository.append(category: selectedCategory, item: data)
                } else {
                    if let modifyTodo = self.modifyTodo {
                        self.repository.update(id: modifyTodo.id, newItem: data)
                    } else {
                        self.repository.add(item: data)
                    }
                }
            
                if let pickedImage = self.pickedImage {
                    self.saveImageToDocument(image: pickedImage, filename: "\(data.id)")
                }
            }
            
            self.dismiss(animated: true)
        }
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
        addTodoTableView.tableHeaderView = todoHeaderView
        
        todoHeaderView.memoTextView.delegate = self
        
        if let titleString {
            todoHeaderView.titleTextField.text = titleString
        }
        
        if let memoString {
            todoHeaderView.memoTextView.text = memoString
        }
    }
    
    private func addImage() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.overrideUserInterfaceStyle = .dark
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
        
        let index = indexPath.row
        
        switch todoCategoryList[index] {
        case .duedate:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoTableViewCell", for: indexPath) as! AddTodoTableViewCell
            cell.titleLabel.text = todoCategoryList[index].rawValue
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd."
            
            if let selectedDate {
                cell.subtitleLabel.text = formatter.string(from: selectedDate)
            }
            
            return cell
            
        case .tag:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoTableViewCell", for: indexPath) as! AddTodoTableViewCell
            cell.titleLabel.text = todoCategoryList[index].rawValue
            
            cell.subtitleLabel.text = selectedTag
            return cell
            
        case .priority:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoTableViewCell", for: indexPath) as! AddTodoTableViewCell
            cell.titleLabel.text = todoCategoryList[index].rawValue
            
            if let priorityValue = selectedPriority {
                cell.subtitleLabel.text = Priority(rawValue: priorityValue)?.string
            } else {
                cell.subtitleLabel.text = nil
            }
            return cell
            
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoImageTableViewCell", for: indexPath) as! AddTodoImageTableViewCell
            
            let addImageButtonClosure = { (action: UIAction) in
                if action.title == "사진 보관함" {
                    print("사진 보관함 탭 선택됨")
                    self.addImage()
                } else if action.title == "사진 찍기" {
                    
                } else if action.title == "웹에서 불러오기" {
                    
                }
            }
            
            cell.addImageButton.menu = UIMenu(title: "이미지 추가", children: [
                UIAction(title: "사진 보관함", image: UIImage(systemName: "photo"), handler: addImageButtonClosure),
                UIAction(title: "사진 찍기", image: UIImage(systemName: "camera"), handler: addImageButtonClosure),
                UIAction(title: "웹에서 불러오기", image: UIImage(systemName: "safari"), handler: addImageButtonClosure)
            ])
            
            cell.addImageButton.showsMenuAsPrimaryAction = true
            
            if let pickedImage {
                cell.pickedImageView.image = pickedImage
            }
            
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
            
            cell.backView.backgroundColor = SeSACColor.slightDarkGray.color
            cell.backView.snp.remakeConstraints { make in
                make.edges.equalTo(cell.contentView.safeAreaLayoutGuide).inset(8)
            }
            
            // TODO: 상세 뷰에서 선택된 목록의 내용과 색으로 변경해 주어야 함
            if let data = selectedCategory {
                if let colorIndex = data.color {
                    cell.iconImageBackView.backgroundColor = colorList[colorIndex].color
                }
                
                cell.titleLabel.text = data.name
            } else {
                cell.titleLabel.text = "목록"
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedRowType = todoCategoryList[index]
        
        switch selectedRowType {
        case .duedate:
            let vc = DueDateViewController()
            
            vc.dateSpace = { date in
                print("dateSpace 전달됨")
                print("날짜 뷰에서 \(date) 가 선택되었습니다")
                self.selectedDate = date
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        case .tag:
            let vc = TagViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .priority:
            let vc = PriorityViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .image:
            print("") // 안에 존재하는 버튼에서 처리 중
        case .category:
            let vc = AddListFromExistViewController()
            
            vc.categorySpace = { category in
                self.selectedCategory = category
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모" {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "메모"
            textView.textColor = .gray
        }
    }
    
}

extension AddTodoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImage = pickedImage
        }
        
        dismiss(animated: true)
    }
}
