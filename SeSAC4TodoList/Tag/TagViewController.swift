//
//  TagViewController.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit

class TagViewController: BaseViewController {

    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tagText = textField.text {
            NotificationCenter.default.post(name: NSNotification.Name("tagNotification"), object: nil, userInfo: ["tag": tagText])
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(textField)
    }
    
    override func configureConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        view.backgroundColor = SeSACColor.veryDarkGray.color
        
        textField.textColor = .white
        textField.backgroundColor = SeSACColor.slightDarkGray.color
        textField.attributedPlaceholder = NSAttributedString(string: "태그를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.font = .systemFont(ofSize: 16)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
    }
}
