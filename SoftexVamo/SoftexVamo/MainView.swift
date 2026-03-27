//
//  MainView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 27/03/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query var ciclos: [CicloSoftexSD]
    
    var body: some View {
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
}

#Preview {
    MainView()
}
