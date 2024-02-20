//
//  AddListSelectColorCollectionViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit

class AddListSelectColorCollectionViewCell: BaseCollectionViewCell {
    
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(colorView)
    }
    
    override func configureConstraints() {
        colorView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
        
        colorView.backgroundColor = .red
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
