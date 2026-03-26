//
//  NewCicloView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 26/03/26.
//

import SwiftUI
import Combine

struct NewCicloView: View {
    @EnvironmentObject var viewModel: NewCicloViewModel
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var totalValue: Float = 2500
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Valor do Gasto", value: $totalValue, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                    DatePicker("Dia de Inicio", selection: $startDate, displayedComponents: .date)
                    DatePicker("Dia de Inicio", selection: $endDate, displayedComponents: .date)
                }
                if !viewModel.textResult.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            Text(viewModel.textResult)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Criar Novo Ciclo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("", systemImage: "checkmark.circle") {
                    viewModel.createNewCiclo(startDate: startDate, endDate: endDate, totalValue: totalValue)
                }
            }
        }
    }
}

#Preview {
    NewCicloView()
        .environmentObject(NewCicloViewModel())
}

final class NewCicloViewModel: ObservableObject {
    @Published var textResult = ""
    
    func createNewCiclo(startDate: Date, endDate: Date, totalValue: Float) {
        var days: [DiaSoftex] = []
        let dayCount = Calendar.current.datesBetween(startDate, and: endDate)
        let saldo = totalValue / Float(dayCount)
        for i in 0...dayCount - 1 {
            let time = 86400 * i
            let date = startDate.addingTimeInterval(TimeInterval(time))
            days.append(DiaSoftex(gastos: [], data: date, saldo: saldo))
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let periodo = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        
        let newCiclo = CicloSoftex(valor_total: totalValue, gasto_total: 0, periodo: periodo, diaria: saldo, dias: days)
        
        printNewCicloData(newCiclo, numberOfDays: dayCount)
    }
    
    func printNewCicloData(_ newCiclo: CicloSoftex, numberOfDays: Int) {
        let text = """
            \(newCiclo.periodo)
            Quantidade de Dias: \(numberOfDays)
            Valor Total: \(newCiclo.valor_total.formatted(.currency(code: "BRL")))
            Valor por Dia: \(newCiclo.diaria.formatted(.currency(code: "BRL")))
            """
        textResult = text
    }
}
