//
//  TodoModel.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit

enum Priority: String {
    
    case high = "높음"
    case middle = "중간"
    case low = "낮음"
}

enum TodoType: String, CaseIterable{
    
    case today = "오늘"
    case scheduled = "예정"
    case all = "전체"
    case flagged = "깃발 표시"
    case completed = "완료됨"
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "exclamationmark.circle")
        case .scheduled:
            return UIImage(systemName: "calendar.badge.clock")
        case .all:
            return UIImage(systemName: "tray.fill")
        case .flagged:
            return UIImage(systemName: "flag.fill")
        case .completed:
            return UIImage(systemName: "checkmark")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .today:
            return .systemBlue
        case .scheduled:
            return .systemRed
        case .all:
            return .systemGray
        case .flagged:
            return .systemYellow
        case .completed:
            return .systemGray
        }
    }
}

struct TodoModel {
    
    var title: String       // 제목
    var description: String // 메모
    var iconImage: UIImage  // 아이콘 이미지
    var dueDate: Date       // 마감일
    var isCompleted: Bool   // 완료 여부
    var isFlagged: Bool     // 깃발 여부
    var priority: Priority  // 우선 순위
}
