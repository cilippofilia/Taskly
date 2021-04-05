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
                                ProjectSummaryView(project: project)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        TaskListView(title: "Up next", tasks: tasks.wrappedValue.prefix(3))
                        TaskListView(title: "More to explore", tasks: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
