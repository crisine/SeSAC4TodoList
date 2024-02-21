//
//  TodoRepository.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/22/24.
//

import RealmSwift
import Foundation

class TodoRepository: TodoRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func add(item: TodoModel) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("an error occured while adding items to Realm databse: \(error)")
        }
    }
    
    func fetch() -> RealmSwift.Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
    
    func fetchFilter(_ predicate: NSPredicate) -> RealmSwift.Results<TodoModel> {
        return realm.objects(TodoModel.self).filter(predicate)
    }
    
    func update(item: TodoModel) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("an error occured while updating items to Realm databse: \(error)")
        }
    }
    
    func delete(item: TodoModel) {
        realm.delete(item)
    }
    
}
