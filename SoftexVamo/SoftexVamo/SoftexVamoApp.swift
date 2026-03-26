//
//  SoftexVamoApp.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 25/03/26.
//

import SwiftUI
import SwiftData

@main
struct SoftexVamoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
            TabView {
                CiclosListView()
                    .environmentObject(CiclosListViewModel())
                    .tabItem {
                        Label("Ciclos", systemImage: "airplane.up.right")
                    }
                NewCicloView()
                    .environmentObject(NewCicloViewModel())
                    .tabItem {
                        Label("Novo Ciclo", systemImage: "plus")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
