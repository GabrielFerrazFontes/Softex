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
        VStack {
            Chart(info) { gasto in
                SectorMark(
                    angle: .value("Valor", gasto.valor),
                    innerRadius: MarkDimension.ratio(0.6),
                    angularInset: 4
                )
                    .cornerRadius(8)
                    .foregroundStyle(by: .value("Gastos", gasto.titulo))
            }
        }
    }
}



#Preview {
    CicloInfoView(info: .constant([
        GastosDia(valor: 200, titulo: "Gasto"),
        GastosDia(valor: 2000, titulo: "Sobrando")
    ]))
}
