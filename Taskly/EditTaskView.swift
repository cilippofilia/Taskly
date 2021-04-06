//
//  EditTaskView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import SwiftUI

struct EditTaskView: View {
    let task: Task

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    init(task: Task) {
        self.task = task

        _title = State(wrappedValue: task.taskTitle)
        _detail = State(wrappedValue: task.taskDetail)
        _priority = State(wrappedValue: Int(task.priority))
        _completed = State(wrappedValue: task.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Task name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Task")
        .onDisappear(perform: dataController.save)
    }

    func update() {
        task.project?.objectWillChange.send()

        task.title = title
        task.detail = detail
        task.priority = Int16(priority)
        task.completed = completed
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(task: Task.example)
    }
}
