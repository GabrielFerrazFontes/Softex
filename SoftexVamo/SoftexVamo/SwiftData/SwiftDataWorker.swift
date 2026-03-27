//
//  SwiftDataWorker.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 27/03/26.
//

import SwiftUI
import SwiftData

struct SwiftDataWorker {
    @Environment(\.modelContext) var modelContext
    
    func createCiclo(_ newCiclo: CicloSoftex) {
        let cicloSD = transformCiclo(newCiclo)
        modelContext.insert(cicloSD)
    }
    
    func updateCiclo(_ ciclo: CicloSoftexSD, newData: CicloSoftex) {
        ciclo.dias = newData.dias
        ciclo.valorTotal = newData.valorTotal
        ciclo.gastoTotal = newData.gastoTotal
        ciclo.periodo = newData.periodo
        ciclo.diaria = newData.diaria
        modelContext.insert(ciclo)
    }
    
    func deleteCiclo(_ ciclo: CicloSoftex) {
        let cicloSD = transformCiclo(ciclo)
        modelContext.delete(cicloSD)
    }
    
    private func transformCiclo(_ ciclo: CicloSoftex) -> CicloSoftexSD {
        CicloSoftexSD(
            dias: ciclo.dias,
            valorTotal: ciclo.valorTotal,
            gastoTotal: ciclo.gastoTotal,
            periodo: ciclo.periodo,
            diaria: ciclo.diaria
        )
    }
    
    func createDias(_ dias: [DiaSoftex]) {
        var diasSD = [DiaSoftexSD]()
        for dia in dias {
            diasSD.append(transformDia(dia))
        }
    }
    
    func transformDia(_ dia: DiaSoftex) -> DiaSoftexSD {
        DiaSoftexSD(
            id: dia.id,
            gastos: dia.gastos,
            data: dia.data,
            saldo: dia.saldo
        )
    }
}
