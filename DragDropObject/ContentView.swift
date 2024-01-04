//
//  ContentView.swift
//  DragDropObject
//
//  Created by labuser on 5/1/2024.
//

import SwiftUI
import Algorithms

struct ContentView: View {

    @State private var toDoTasks: [String] = ["@Observable Migration", "Keyframe Animations", "Migrate to Swift Data"]
    @State private var inProgressTasks: [String] = []
    @State private var doneTasks: [String] = []
    @State private var isInProgressTargeted: Bool = false
    @State private var isToDoTargeted: Bool = false
    @State private var isDoneTargeted: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for: String.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inProgressTasks.removeAll(where: {$0 == task})
                        doneTasks.removeAll(where: {$0 == task})
                    }
                    let totalTasks = toDoTasks + droppedTasks
                    toDoTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            
            KanbanView(title: "In Progress", tasks: inProgressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for: String.self) { droppedTasks, location in
                    for task in droppedTasks {
                        toDoTasks.removeAll(where: {$0 == task})
                        doneTasks.removeAll(where: {$0 == task})
                    }
                    let totalTasks = inProgressTasks + droppedTasks
                    inProgressTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isInProgressTargeted = isTargeted
                }
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for: String.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inProgressTasks.removeAll(where: {$0 == task})
                        toDoTasks.removeAll(where: {$0 == task})
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
    let tasks: [String]
    let isTargeted: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.footnote.bold())

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .green.opacity(0.2) : Color(.secondarySystemFill))

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
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
