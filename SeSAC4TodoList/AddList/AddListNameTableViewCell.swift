//
//  AddListNameTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit
import SnapKit
import SwiftUI

class AddListNameTableViewCell: BaseTableViewCell {

    let customBackgroundView = UIView()
    let listIconImageBackView = UIView()
    let listIconImageView = UIImageView()
    let listNameTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        [customBackgroundView, listIconImageBackView, listIconImageView, listNameTextField].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        customBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(16)
        }
        
        listIconImageBackView.snp.makeConstraints { make in
            make.centerX.equalTo(customBackgroundView)
            make.top.equalTo(customBackgroundView).offset(16)
            make.size.equalTo(80)
        }
        
        listIconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(listIconImageBackView)
            make.size.equalTo(56)
        }
        
        listNameTextField.snp.makeConstraints { make in
            make.top.equalTo(listIconImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(customBackgroundView).inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(customBackgroundView).inset(16)
        }
    }
    
    override func configureView() {
        backgroundColor = SeSACColor.veryDarkGray.color
        selectionStyle = .none
        
        customBackgroundView.backgroundColor = SeSACColor.slightDarkGray.color
        customBackgroundView.clipsToBounds = true
        customBackgroundView.layer.cornerRadius = 8
        
        listIconImageBackView.backgroundColor = .darkGray
        listIconImageBackView.clipsToBounds = true
        listIconImageBackView.layer.cornerRadius = 40
        
        listIconImageView.tintColor = .white
        listIconImageView.image = UIImage(systemName: "list.bullet")
        listIconImageView.contentMode = .scaleAspectFit
        
        listNameTextField.backgroundColor = .darkGray
        listNameTextField.clipsToBounds = true
        listNameTextField.layer.cornerRadius = 8
        listNameTextField.textColor = .white
        listNameTextField.font = .boldSystemFont(ofSize: 24)
        listNameTextField.textAlignment = .center
        listNameTextField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
