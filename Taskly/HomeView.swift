//
//  HomeView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import SwiftUI
import CoreData

struct HomeView: View {
    static let homeTag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Project.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
                  predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>

    let tasks: FetchRequest<Task>
    
    init() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Task.priority, ascending: false)
        ]
        
        request.fetchLimit = 10
        tasks = FetchRequest(fetchRequest: request)
    }

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects) { project in
                                VStack(alignment: .leading) {
                                    Text("\(project.projectTasks.count) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(project.projectTitle)
                                        .font(.title2)

                                    ProgressView(value: project.completionAmount)
                                        .accentColor(Color(project.projectColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        list("Up next", for: tasks.wrappedValue.prefix(3))
                        list("More to explore", for: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder func list(_ title: String, for tasks: FetchedResults<Task>.SubSequence) -> some View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
