//
//  ContentView.swift
//  DragDropObject
//
//  Created by labuser on 5/1/2024.
//

import SwiftUI
import Algorithms
import UniformTypeIdentifiers


struct ContentView: View {

    @State private var toDoTasks: [Athlete] = [MockData.athlete1, MockData.athlete2, MockData.athlete3]
    @State private var inProgressTasks: [Athlete] = []
    @State private var doneTasks: [Athlete] = []
    @State private var isInProgressTargeted: Bool = false
    @State private var isToDoTargeted: Bool = false
    @State private var isDoneTargeted: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for: Athlete.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inProgressTasks.removeAll(where: {$0.id == task.id})
                        doneTasks.removeAll(where: {$0.id == task.id})
                    }
                    let totalTasks = toDoTasks + droppedTasks
                    toDoTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            
            KanbanView(title: "In Progress", tasks: inProgressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for: Athlete.self) { droppedTasks, location in
                    for task in droppedTasks {
                        toDoTasks.removeAll(where: {$0.id == task.id})
                        doneTasks.removeAll(where: {$0.id == task.id})
                    }
                    let totalTasks = inProgressTasks + droppedTasks
                    inProgressTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isInProgressTargeted = isTargeted
                }
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for: Athlete.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inProgressTasks.removeAll(where: {$0.id == task.id})
                        toDoTasks.removeAll(where: {$0.id == task.id})
                    }
                    let totalTasks = doneTasks + droppedTasks
                    doneTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isDoneTargeted = isTargeted
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct KanbanView: View {

    let title: String
    let tasks: [Athlete]
    let isTargeted: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.footnote.bold())

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .green.opacity(0.2) : Color(.secondarySystemFill))

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(tasks, id: \.id) { task in
                        Text(task.name)
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1, x: 1, y: 1)
                            .draggable(task)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

struct Athlete: Codable, Hashable, Transferable {
    
    static func == (lhs: Athlete, rhs: Athlete) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.weight == rhs.weight
    }
    
    let id: UUID
    let name: String
    let weight: Int
    
    init(id: UUID, name: String, weight: Int) {
        self.id = id
        self.name = name
        self.weight = weight
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .athlete)
    }
}

extension UTType {
    static let athlete = UTType(exportedAs: "com.petrvalouch.athlete")
}

struct MockData {
    static let athlete1 = Athlete(id: UUID(), name: "Petr Valouch", weight: 72)
    static let athlete2 = Athlete(id: UUID(), name: "Jocelyn", weight: 65)
    static let athlete3 = Athlete(id: UUID(), name: "George", weight: 80)
}
