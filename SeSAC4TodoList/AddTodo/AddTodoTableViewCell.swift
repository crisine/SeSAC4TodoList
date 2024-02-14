//
//  AddTodoTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit

class AddTodoTableViewCell: UITableViewCell {

    let backView = UIView()
    let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .white
        
        return view
    }()
    let subtitleLabel: UILabel = {
        let view = UILabel()
       
        view.font = .systemFont(ofSize: 16)
        view.textColor = .lightGray
        
        return view
    }()
    let modifyButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = .gray
        view.backgroundColor = .clear
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [backView, titleLabel, subtitleLabel, modifyButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(16)
            make.width.greaterThanOrEqualTo(120)
        }
        
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(backView).offset(-8)
            make.size.equalTo(40)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.trailing.equalTo(modifyButton.snp.leading).offset(-8)
            make.width.lessThanOrEqualTo(160)
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        
        backView.backgroundColor = SeSACColor.slightDarkGray.color
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
