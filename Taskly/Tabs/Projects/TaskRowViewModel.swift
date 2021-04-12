//
//  TaskRowViewModel.swift
//  Taskly
//
//  Created by Filippo Cilia on 12/04/2021.
//

import Foundation

extension TaskRowView {
    class ViewModel: ObservableObject {
        let project: Project
        let task: Task

        var title: String {
            task.taskTitle
        }

        var icon: String {
            if task.completed {
                return "checkmark.circle"

            } else if task.priority == 3 {
                return "exclamationmark.triangle"

            } else {
                return "checkmark.circle"
            }
        }

        var color: String? {
            if task.completed {
                return project.projectColor

            } else if task.priority == 3 {
                return project.projectColor

            } else {
                return nil
            }
        }

        var label: String {
            if task.completed {
                return "\(task.taskTitle), completed."
            } else if task.priority == 3 {
                return "\(task.taskTitle), high priority."
            } else {
                return task.taskTitle
            }
        }

        init(project: Project, task: Task) {
            self.project = project
            self.task = task
        }
    }
}
