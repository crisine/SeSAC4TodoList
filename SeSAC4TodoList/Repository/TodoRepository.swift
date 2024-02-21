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
    
    func append(category: TodoCategory, item: TodoModel) {
        do {
            try realm.write {
                category.todo.append(item)
            }
        } catch {
            print("an error occured while appending items on \(category) on Realm databse: \(error)")
        }
    }
    
    func fetch() -> RealmSwift.Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
    
    func fetchFilter(_ predicate: NSPredicate) -> RealmSwift.Results<TodoModel> {
        return realm.objects(TodoModel.self).filter(predicate)
    }
    
    func update(id: ObjectId, newItem: TodoModel) {
        do {
            try realm.write {
                realm.create(TodoModel.self,
                             value: ["id": id,
                                     "title": newItem.title,
                                     "memo": newItem.memo,
                                     "dueDate": newItem.dueDate,
                                     "tag": newItem.tag,
                                     "priority": newItem.priority],
                             update: .modified)
            }
        } catch {
            print("an error occured while updating items to Realm databse: \(error)")
        }
    }
    
    func delete(item: TodoModel) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("an error occured while deleting item from Realm databse: \(error)")
        }
    }
    
}
