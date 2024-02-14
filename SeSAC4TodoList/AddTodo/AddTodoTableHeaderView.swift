//
//  AddTodoTableHeaderView.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit

class AddTodoTableHeaderView: UIView {
    
    let backView = UIView()
    let separatorLineView = UIView()
    let titleTextField = UITextField()
    let descriptionTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [backView, separatorLineView, titleTextField, descriptionTextField].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(8)
            make.horizontalEdges.equalTo(backView).inset(8)
            make.height.equalTo(40)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(backView).inset(8)
            make.height.equalTo(0.5)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(backView).inset(8)
            make.bottom.equalTo(backView.snp.bottom).inset(8)
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        
        backView.backgroundColor = SeSACColor.slightDarkGray.color
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
        
        separatorLineView.backgroundColor = .darkGray
        
        titleTextField.placeholder = "제목"
        titleTextField.textColor = .white
        
        descriptionTextField.placeholder = "메모"
        descriptionTextField.textColor = .white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
