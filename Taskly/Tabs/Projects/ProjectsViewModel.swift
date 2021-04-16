//
//  ProjectsViewModel.swift
//  Taskly
//
//  Created by Filippo Cilia on 12/04/2021.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Task.SortOrder.optimized
        let showClosedProjects: Bool

        private let projectsController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()
        @Published var showingUnlockView = false

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects!")
            }
        }

        func addProject() {
            let canCreate = dataController.fullVersionUnlocked || dataController.count(for: Project.fetchRequest()) < 3

            if canCreate {
                let project = Project(context: dataController.container.viewContext)
                project.closed = false
                project.creationDate = Date()
                dataController.save()
            } else {
                showingUnlockView.toggle()
            }
        }

        func addTask(to project: Project) {
            let task = Task(context: dataController.container.viewContext)
            task.project = project
            task.creationDate = Date()
            dataController.save()

        }

        func delete(_ offsets: IndexSet, from project: Project) {
            let allTasks = project.projectTasks(using: sortOrder)

            for offset in offsets {
                let task = allTasks[offset]
                dataController.delete(task)
            }

            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProject = controller.fetchedObjects as? [Project] {
                projects = newProject
            }
        }
    }
}
