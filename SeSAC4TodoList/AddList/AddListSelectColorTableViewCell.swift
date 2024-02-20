//
//  AddListSelectColorTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import Foundation
import UIKit
import SwiftUI

class AddListSelectColorTableViewCell: BaseTableViewCell {
    
    let customBackgroundView = UIView()
    let selectColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 4
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    override func configureHierarchy() {
        [customBackgroundView, selectColorCollectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        customBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(16)
            make.height.equalTo(64)
        }
        
        // TODO: 제약설정에 문제있는 것 같음
        selectColorCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(customBackgroundView).inset(8)
        }
    }
    
    override func configureView() {
        selectionStyle = .none
        
        backgroundColor = .clear
        
        customBackgroundView.backgroundColor = SeSACColor.slightDarkGray.color
        customBackgroundView.clipsToBounds = true
        customBackgroundView.layer.cornerRadius = 8
        
        selectColorCollectionView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//struct CustomCellPreview: PreviewProvider {
//    
//    static var previews: some View {
//        CellPreviewContainer().frame(width: UIScreen.main.bounds.width - 16, height: 60, alignment: .center)
//    }
//    
//    struct CellPreviewContainer: UIViewRepresentable {
//        
//        func makeUIView(context: UIViewRepresentableContext<CustomCellPreview.CellPreviewContainer>) -> UITableViewCell {
//            return AddListSelectColorTableViewCell()
//        }
//        
//        func updateUIView(_ uiView: UITableViewCell, context: UIViewRepresentableContext<CustomCellPreview.CellPreviewContainer>) {
//            
//        }
//        
//        typealias UIViewType = UITableViewCell
//    }
//}
