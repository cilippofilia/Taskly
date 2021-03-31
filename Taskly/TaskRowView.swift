//
//  TaskRowView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var task: Task

    var icon: some View {
        if task.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
            
        } else if task.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
            
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditTaskView(task: task)) {
            Label {
                Text(task.taskTitle)
            } icon: {
                icon
            }
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(project: Project.example, task: Task.example)
    }
}