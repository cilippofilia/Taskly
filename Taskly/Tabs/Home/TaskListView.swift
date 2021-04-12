//
//  TaskListView.swift
//  Taskly
//
//  Created by Filippo Cilia on 05/04/2021.
//

import SwiftUI

struct TaskListView: View {
    let title: LocalizedStringKey
    let tasks: ArraySlice<Task>

    var body: some View {
        if tasks.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(tasks) { task in
                NavigationLink(destination: EditTaskView(task: task)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(task.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(task.taskTitle)
                                .font(.title2)
                                .foregroundColor(.primary)

                            if task.taskDetail.isEmpty == false {
                                Text(task.taskDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}

//  struct TaskListView_Previews: PreviewProvider {
//      static var previews: some View {
//          TaskListView(title: "example", tasks: Task.example)
//      }
//  }
