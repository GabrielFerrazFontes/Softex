//
//  CiclosListView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 25/03/26.
//

import SwiftUI
import Combine

struct CiclosListView: View {
    @EnvironmentObject var viewModel: CiclosListViewModel
    
    @State var addNewGastoSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("", systemImage: "arrow.left") {
                    viewModel.previousCiclo()
                }
                .padding(.leading)
                Spacer()
                Text(viewModel.actualCiclo.periodo)
                Spacer()
                Button("", systemImage: "arrow.right") {
                    viewModel.nextCiclo()
                }
                .padding(.trailing)
            }
            CicloInfoView(gastos: $viewModel.gastosInfo, available: $viewModel.availableInfo)
                .frame(width: 250, height: 250)
            CicloGastosView() {
                addNewGastoSheet.toggle()
            }
                .environmentObject(CicloGastosViewModel(ciclo: viewModel.actualCiclo))
        }
        .onAppear {
            viewModel.fetchAllCiclos()
        }
        .sheet(isPresented: $addNewGastoSheet) {
            AddNewGastoSheetView { title, value, date in
                viewModel.createNewGasto(title: title, value: value, date: date)
            }
        }
    }
}

final class CiclosListViewModel: ObservableObject {
    @Published var actualCiclo: CicloSoftex = CicloSoftex.example
    @Published var gastosInfo: GastosDia = GastosDia.example
    @Published var availableInfo: GastosDia = GastosDia.example
    var allCiclos: [CicloSoftex] = []
    var index: Int = 0
    
    func fetchAllCiclos() {
        allCiclos = CicloSoftex.examples
        actualCiclo = allCiclos.last ?? CicloSoftex.example
        index = allCiclos.count - 1
        updateCicloInfo()
    }
    
    func nextCiclo() {
        guard index <= allCiclos.count - 2 else { return }
        index += 1
        actualCiclo = allCiclos[index]
        updateCicloInfo()
    }
    
    func previousCiclo() {
        guard index > 0 else { return }
        index -= 1
        actualCiclo = allCiclos[index]
        updateCicloInfo()
    }
    
    private func updateCicloInfo() {
        let available = actualCiclo.valorTotal - actualCiclo.gastoTotal
        gastosInfo = GastosDia(valor: actualCiclo.gastoTotal, titulo: "Gasto")
        availableInfo = GastosDia(valor: available, titulo: "Disponivel")
    }
    
    func createNewGasto(title: String, value: Decimal, date: Date) {
        let valueFloat = Float(value.description) ?? 0.0
        let gasto = GastosDia(valor: valueFloat, titulo: title)
        actualCiclo.gastoTotal += valueFloat
        print(gasto)
    }
}

#Preview {
    CiclosListView()
        .environmentObject(CiclosListViewModel())
}
