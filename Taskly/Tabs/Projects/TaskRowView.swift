//
//  TaskRowView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import SwiftUI

struct TaskRowView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var task: Task

    var body: some View {
        NavigationLink(destination: EditTaskView(task: task)) {
            Label {
                Text(task.taskTitle)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
            }
        }
        .accessibilityLabel(viewModel.label)
    }

    init(project: Project, task: Task) {
        let viewModel = ViewModel(project: project, task: task)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.task = task
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(project: Project.example, task: Task.example)
    }
}
