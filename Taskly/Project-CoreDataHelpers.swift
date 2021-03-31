//
//  Project-CoreDataHelpers.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import Foundation

extension Project {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectTasksDefaultSorted: [Task] {
        projectTasks.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            return first.taskCreationDate < second.taskCreationDate
        }
    }
    
    var projectTasks: [Task] {
        tasks?.allObjects as? [Task] ?? []
    }
    
    var completionAmount: Double {
        let originalTasks = tasks?.allObjects as? [Task] ?? []
        guard originalTasks.isEmpty == false else { return 0 }
        
        let completedTasks = originalTasks.filter(\.completed)
        return Double(completedTasks.count) / Double(originalTasks.count)
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()
        
        return project
    }
    
    func projectTasks(using sortOrder: Task.SortOrder) -> [Task] {
        switch sortOrder {
            case .title:
                return projectTasks.sorted(by: \Task.taskTitle)
                
            case .creationDate:
                return projectTasks.sorted(by: \Task.taskCreationDate)
                
            case .optimized:
                return projectTasksDefaultSorted
        }
    }

    func projectTasks<Value: Comparable>(sortedBy keyPath: KeyPath<Task, Value>) -> [Task] {
        projectTasks.sorted {
            $0[keyPath: keyPath] < $1[keyPath: keyPath]
        }
    }
}
