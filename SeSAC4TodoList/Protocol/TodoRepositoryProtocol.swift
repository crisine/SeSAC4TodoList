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
    
    func fetch() -> Results<TodoModel>
    func fetchFilter(_ filter: NSPredicate) -> Results<TodoModel>
    
    func update(item: TodoModel)
    
    func delete(item: TodoModel)
}
