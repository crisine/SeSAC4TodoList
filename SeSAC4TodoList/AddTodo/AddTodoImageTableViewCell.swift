//
//  AddTodoImageTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/20/24.
//

import UIKit
import SnapKit

class AddTodoImageTableViewCell: UITableViewCell {
    
    let backView = UIView()
    let addImageButton = UIButton()
    let pickedImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [backView, addImageButton, pickedImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(16)
            make.width.lessThanOrEqualTo(120)
        }
        
        pickedImageView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).inset(16)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        
        backView.backgroundColor = SeSACColor.slightDarkGray.color
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
        
        addImageButton.setTitle("이미지 추가", for: .normal)
        addImageButton.setTitleColor(.systemBlue, for: .normal)
        addImageButton.titleLabel?.font = .systemFont(ofSize: 16)
        addImageButton.backgroundColor = .clear
        
        pickedImageView.backgroundColor = .clear
        pickedImageView.clipsToBounds = true
        pickedImageView.layer.cornerRadius = 16
        pickedImageView.contentMode = .scaleAspectFill
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
