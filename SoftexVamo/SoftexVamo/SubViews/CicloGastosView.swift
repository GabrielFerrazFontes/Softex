//
//  CicloGastosView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 25/03/26.
//

import SwiftUI
import Combine

struct CicloGastosView: View {
    @EnvironmentObject var viewModel: CicloGastosViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach($viewModel.ciclo.dias) { $dia in
                    Section(header: createSectionHeader(dia: dia)) {
                        ForEach(dia.gastos) { gasto in
                            createGastoCell(gasto: gasto)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteGasto(dia: &dia, offsets: indexSet)
                        }
                    }
                }
            }
            Button("Apagar Ciclo", systemImage: "trash") {
                print("Delete")
            }
            .foregroundStyle(.red)
        }
    }
    
    @ViewBuilder func createSectionHeader(dia: DiaSoftex) -> some View {
        HStack {
            Text(viewModel.dateToString(date: dia.data))
                .padding(.trailing)
            Spacer()
            Text(dia.saldo, format: .currency(code: "BRL").precision(.fractionLength(2)))
                .foregroundStyle(dia.saldo > 0 ? Color.blue : Color.red)
                .padding(.leading)
        }
    }
    
    @ViewBuilder func createGastoCell(gasto: GastosDia) -> some View {
        HStack {
            Text(gasto.titulo)
                .font(.callout)
            Spacer()
            Text(gasto.valor, format: .currency(code: "BRL"))
                .foregroundStyle(Color.red)
        }
    }
}

#Preview {
    CicloGastosView()
        .environmentObject(CicloGastosViewModel(ciclo: CicloSoftex.example))
}

final class CicloGastosViewModel: ObservableObject {
    @Published var ciclo: CicloSoftex = CicloSoftex.example
    
    init(ciclo: CicloSoftex) {
        self.ciclo = ciclo
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func deleteGasto(dia: inout DiaSoftex, offsets: IndexSet) {
        dia.gastos.remove(atOffsets: offsets)
    }
}
