//
//  SwiftDataModels.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 27/03/26.
//

import Foundation
import SwiftData

@Model class CicloSoftexSD {
    var dias: [DiaSoftex]
    var valorTotal: Float
    var gastoTotal: Float
    var periodo: String
    var diaria: Float
    
    init(dias: [DiaSoftex], valorTotal: Float, gastoTotal: Float, periodo: String, diaria: Float) {
        self.dias = dias
        self.valorTotal = valorTotal
        self.gastoTotal = gastoTotal
        self.periodo = periodo
        self.diaria = diaria
    }
}

@Model class DiaSoftexSD: Identifiable {
    var id: UUID
    var gastos: [GastosDia]
    var data: Date
    var saldo: Float
    
    init(id: UUID, gastos: [GastosDia], data: Date, saldo: Float) {
        self.id = id
        self.gastos = gastos
        self.data = data
        self.saldo = saldo
    }
}

@Model class GastosDiaSD: Identifiable {
    var id: UUID
    var valor: Float
    var titulo: String
    
    init(id: UUID, valor: Float, titulo: String) {
        self.id = id
        self.valor = valor
        self.titulo = titulo
    }
}

