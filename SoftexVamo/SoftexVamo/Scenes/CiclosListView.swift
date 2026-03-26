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
            } deleteAction: { diaID, gastoID in
                viewModel.deleteGasto(diaID: diaID, gastoID: gastoID)
            }
                .environmentObject(CicloGastosViewModel(ciclo: viewModel.actualCiclo))
        }
        .onAppear {
            Task{
                await viewModel.fetchAllCiclos()
            }
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
    
    func fetchAllCiclos1() async {
        guard let url = URL(string: "http://127.0.0.1:8000/usuario/ciclos/1") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
        

            let ciclos = try decoder.decode([CicloSoftex].self, from: data)
            
            print(ciclos)

            DispatchQueue.main.async {
                self.allCiclos = ciclos
                self.actualCiclo = ciclos.last!
                self.index = ciclos.count - 1
                self.updateCicloInfo()
            }

        } catch {
            
            print("Erro ao buscar ciclos:", error)
        }
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
    
    func fetchAllCiclos1() {
        allCiclos = CicloSoftex.examples // Network
        actualCiclo = allCiclos.last ?? CicloSoftex.example
        index = allCiclos.count - 1
        updateCicloInfo()
        let available = actualCiclo.valor_total - actualCiclo.gasto_total
        valueInfo = [
            GastosDia(valor: actualCiclo.gasto_total, titulo: "Gasto"),
            GastosDia(valor: available, titulo: "Disponivel")
        ]
    }
    
    func createNewGasto(title: String, value: Decimal, date: Date) {
        let valueFloat = Float(value.description) ?? 0.0
        let gasto = GastosDia(valor: valueFloat, titulo: title)
        actualCiclo.gasto_total += valueFloat
        print(gasto)
        // Network
    }
    
    func deleteGasto(diaID: UUID, gastoID: UUID) {
        // Network
    }
}

#Preview {
    CiclosListView()
        .environmentObject(CiclosListViewModel())
}
