//
//  CategoryTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit

class CategoryTableViewCell: BaseTableViewCell {
    
    let backView = UIView()
    let iconImageBackView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        
        return view
    }()
    let iconImageView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .clear
        view.image = UIImage(systemName: "list.bullet")
        view.tintColor = .white
        
        return view
    }()
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
    }
    
    override func configureHierarchy() {
        [backView, iconImageBackView, iconImageView, titleLabel, subtitleLabel, modifyButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(6)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        iconImageBackView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView).offset(16)
            make.size.equalTo(32)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(iconImageBackView)
            make.size.equalTo(iconImageBackView).inset(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.leading.equalTo(iconImageBackView.snp.trailing).offset(16)
            make.trailing.equalTo(modifyButton.snp.leading).offset(16)
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
    
    override func configureView() {
        backgroundColor = .clear
        
        backView.backgroundColor = SeSACColor.veryDarkGray.color
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
    
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
