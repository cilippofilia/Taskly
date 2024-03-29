//
//  HomeView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import CoreData
import CoreSpotlight
import SwiftUI

struct HomeView: View {
    static let homeTag: String? = "Home"

    @StateObject var viewModel: ViewModel

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    // Construct a fetch request to show the 10 highest-priority, incomplete items from open projects.
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if let task = viewModel.selectedTask {
                    NavigationLink(
                        destination: EditTaskView(task: task),
                        tag: task,
                        selection: $viewModel.selectedTask,
                        label: EmptyView.init
                    )
                    .id(task)
                }
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects) { project in
                                ProjectSummaryView(project: project)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        TaskListView(title: "Up next", tasks: viewModel.upNext)
                        TaskListView(title: "More to explore", tasks: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightTask)
        }
    }

    func loadSpotlightTask(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectTask(with: uniqueIdentifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
