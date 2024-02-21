//
//  TodoRepositoryProtocol.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/22/24.
//

import Foundation
import RealmSwift

protocol TodoRepositoryProtocol {
    
    func add(item: TodoModel)
    func append(category: TodoCategory, item: TodoModel)
    
    func fetch() -> Results<TodoModel>
    func fetchFilter(_ filter: NSPredicate) -> Results<TodoModel>
    
    func update(id: ObjectId, newItem: TodoModel)
    
    func delete(item: TodoModel)
}
