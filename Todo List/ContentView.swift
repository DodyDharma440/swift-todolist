//
//  ContentView.swift
//  Todo List
//
//  Created by Dodi Aditya on 18/02/23.
//

import SwiftUI
import UIKit

enum Priority: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

extension UIViewController {
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var priority: Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAlertShow = false
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]) private var tasks: FetchedResults<Task>
    
    private func saveTask() {
        do {
            let isExist = tasks.contains { t in
                t.title == title
            }
            
            if isExist {
              isAlertShow = true
            } else {
                let task = Task(context: viewContext)
                task.title = title
                task.priority = priority.rawValue
                task.createdAt = Date()
                
                try viewContext.save()
                
                title = ""
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        
        switch priority {
            case .low:
                return .green
            case .medium:
                return .orange
            case .high:
                return .red
            default:
                return .black
        }
    }
    
    private func updateTask(_ task: Task) {
        task.isFavorite = !task.isFavorite
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasks[index]
            viewContext.delete(task)
            
            do {
               try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                Button("Save") {
                    saveTask()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                List {
                    ForEach(tasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer()
                                .frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                        
                    }.onDelete(perform: deleteTask)
                }
                
                Spacer()
            }
            .navigationTitle("All Tasks")
            .padding()
        }
        .alert("Error", isPresented: $isAlertShow) {
            
        } message: {
            Text("Task is already exist!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistentContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
    }
}
