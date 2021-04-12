//
//  HomeViewModel.swift
//  Taskly
//
//  Created by Filippo Cilia on 12/04/2021.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let tasksController: NSFetchedResultsController<Task>

        @Published var projects = [Project]()
        @Published var tasks = [Task]()

        var dataController: DataController

        var upNext: ArraySlice<Task> {
            tasks.prefix(3)
        }

        var moreToExplore: ArraySlice<Task> {
            tasks.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

//            Construct a fetch request to show all open projects
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

//            Construct a fetch request to show the 10 highest-priority,
//            incomplete tasks from open projects
            let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()

            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

            taskRequest.predicate = compoundPredicate

            taskRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Task.priority, ascending: false)
            ]

            taskRequest.fetchLimit = 10

            tasksController = NSFetchedResultsController(
                fetchRequest: taskRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self
            tasksController.delegate = self

            do {
                try projectsController.performFetch()
                try tasksController.performFetch()

                projects = projectsController.fetchedObjects ?? []
                tasks = tasksController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newTasks = controller.fetchedObjects as? [Task] {
                tasks = newTasks
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
