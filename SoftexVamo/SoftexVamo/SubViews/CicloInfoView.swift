//
//  CicloInfoView.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 26/03/26.
//

import SwiftUI
import Charts

struct CicloInfoView: View {
    @Binding var info: [GastosDia]
    
    var body: some View {
        HStack {
            Chart(info) { gasto in
                SectorMark(
                    angle: .value("Valor", gasto.valor),
                    innerRadius: MarkDimension.ratio(0.6),
                    angularInset: 4
                )
                    .cornerRadius(8)
                    .foregroundStyle(by: .value("Gastos", gasto.titulo))
            }
            VStack(alignment: .leading) {
                Text("\(info.first?.titulo ?? ""): R$\(info.first?.valor ?? 0, specifier: "%.2f")")
                    .foregroundStyle(.red)
                Text("\(info.last?.titulo ?? ""): R$\(info.last?.valor ?? 0, specifier: "%.2f")")
                    .foregroundStyle(.blue)
            }
            .padding(.leading)
        }
    }
}



#Preview {
    CicloInfoView(info: .constant([
        GastosDia(valor: 200, titulo: "Gasto"),
        GastosDia(valor: 2000, titulo: "Sobrando")
    ]))
}
