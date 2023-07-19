//
//  EditProjectView.swift
//  Taskly
//
//  Created by Filippo Cilia on 31/03/2021.
//

import SwiftUI

struct EditProjectView: View {
    @ObservedObject var project: Project

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextEditor(text: $detail.onChange(update))
                    .frame(minHeight: 60, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
            }

            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        colorButton(for: item)
                    }
                }
                .padding(.vertical)
            }

            Section(header: Text("Project reminders")) {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationsError) {
                        Alert(
                            title: Text("Oops!"),
                            message: Text("There was a problem. Please check you have notifications enabled."),
                            primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                            secondaryButton: .cancel()
                        )
                    }

                if remindMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    if project.closed {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }

                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure you want to delete this project? You will also delete all the tasks it contains."),
                  primaryButton: .default(Text("Delete"), action: delete),
                  secondaryButton: .cancel())
        }
        .environmentObject(dataController)
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false

                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil

            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#if DEBUG
struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environmentObject(DataController())
    }
}
#endif
