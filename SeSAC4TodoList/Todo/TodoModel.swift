//
//  TodoModel.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit
import RealmSwift

enum Priority: Int, CaseIterable {
    
    case low, middle, high
    
    var string: String {
        switch self {
        case .low:
            return "낮음"
        case .middle:
            return "중간"
        case .high:
            return "높음"
        }
    }
}

enum TodoType: String, CaseIterable {
    
    case today = "오늘"
    case scheduled = "예정"
    case all = "전체"
    case flagged = "깃발 표시"
    case completed = "완료됨"
    case category = "목록"
    
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
        case .category:
            return UIImage(systemName: "list.bullet")
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
        case .category:
            return .systemBlue
        }
    }
}

class TodoCategory: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var regDate: Date
    @Persisted var color: Int?
    
    @Persisted var todo: List<TodoModel>
    
    convenience init(name: String, regDate: Date) {
        self.init()
        self.name = name
        self.regDate = regDate
    }
}

class TodoModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var memo: String?
    @Persisted var dueDate: Date?
    @Persisted var tag: String?
    @Persisted var priority: Int?
    @Persisted var isCompleted: Bool
    @Persisted var isFlagged: Bool?
    
    @Persisted(originProperty: "todo") var main: LinkingObjects<TodoCategory>

    convenience init(title: String, memo: String? = nil, dueDate: Date? = nil, tag: String? = nil, priority: Int? = nil, isCompleted: Bool = false, isFlagged: Bool? = nil) {
        self.init()
        self.title = title
        self.memo = memo
        self.dueDate = dueDate
        self.tag = tag
        self.priority = priority
        self.isCompleted = isCompleted
        self.isFlagged = isFlagged
    }
}
