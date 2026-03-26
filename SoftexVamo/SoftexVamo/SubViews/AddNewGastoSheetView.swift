//
//  AddNewGastoSheetView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 26/03/26.
//

import SwiftUI

struct AddNewGastoSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var value: Decimal = 0
    @State var date: Date = Date()
    
    let action: (String, Decimal, Date) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Titulo do Gasto", text: $title)
                    TextField("Valor do Gasto", value: $value, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                    DatePicker("Dia do Gasto", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Adicionar Novo Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("", systemImage: "checkmark.circle") {
                    action(title, value, date)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddNewGastoSheetView() { _,_,_ in
        print("action")
    }
}
