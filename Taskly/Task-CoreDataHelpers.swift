//
//  Task-CoreDataHelpers.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import Foundation

extension Task {
    enum SortOrder {
        case optimized, title, creationDate
    }

    var taskTitle: String {
        title ?? NSLocalizedString("New Task", comment: "Create a new task")
    }

    var taskDetail: String {
        detail ?? ""
    }

    var taskCreationDate: Date {
        creationDate ?? Date()
    }

    static var example: Task {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let task = Task(context: viewContext)
        task.title = "Example task"
        task.detail = "This is an example task"
        task.priority = 3
        task.creationDate = Date()

        return task
    }
}
