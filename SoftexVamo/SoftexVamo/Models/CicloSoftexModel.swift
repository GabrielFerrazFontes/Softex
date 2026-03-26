//
//  CicloSoftexModel.swift
//  SoftexVamo
//
//  Created by Gabriel fontes on 25/03/26.
//

import Foundation

struct CicloSoftex {
    var dias: [DiaSoftex]
    let valorTotal: Float
    var gastoTotal: Float
    let periodo: String
    let diaria: Float
    
    static let examples = [
        CicloSoftex(dias: DiaSoftex.examples, valorTotal: 2145, gastoTotal: 0, periodo: "10/03 - 17/03", diaria: 180),
        CicloSoftex(dias: DiaSoftex.examples1, valorTotal: 2446, gastoTotal: 0, periodo: "18/03 - 25/03", diaria: 167),
        CicloSoftex(dias: DiaSoftex.examples, valorTotal: 2162, gastoTotal: 0, periodo: "26/03 - 01/04", diaria: 172)
    ]
    
    static let example = CicloSoftex(dias: DiaSoftex.examples, valorTotal: 2145, gastoTotal: 0, periodo: "10/03 - 17/03", diaria: 180)
}

struct DiaSoftex: Identifiable {
    let id = UUID()
    var gastos: [GastosDia]
    let data: Date
    var saldo: Float
    
    static let examples = [
        DiaSoftex(gastos: GastosDia.examples, data: Date.now, saldo: 124),
        DiaSoftex(gastos: GastosDia.examples1, data: Date.now.addingTimeInterval(86400), saldo: 124),
        DiaSoftex(gastos: GastosDia.examples2, data: Date.now.addingTimeInterval(172800), saldo: 124),
        DiaSoftex(gastos: [], data: Date.now.addingTimeInterval(259200), saldo: 126),
        DiaSoftex(gastos: [], data: Date.now.addingTimeInterval(345600), saldo: 126)
    ]
    
    static let examples1 = [
        DiaSoftex(gastos: GastosDia.examples1, data: Date.now, saldo: 132),
        DiaSoftex(gastos: GastosDia.examples2, data: Date.now.addingTimeInterval(86400), saldo: 132),
        DiaSoftex(gastos: GastosDia.examples, data: Date.now.addingTimeInterval(172800), saldo: 132)
    ]
}

struct GastosDia: Identifiable {
    let id = UUID()
    let valor: Float
    let titulo: String
    
    static let examples = [
        GastosDia(valor: 20, titulo: "Almoco"),
        GastosDia(valor: 30, titulo: "Jantar"),
        GastosDia(valor: 10, titulo: "Uber")
    ]
    
    static let examples1 = [
        GastosDia(valor: 24, titulo: "Almoco"),
        GastosDia(valor: 32, titulo: "Uber"),
        GastosDia(valor: 16, titulo: "Uber")
    ]
    
    static let examples2 = [
        GastosDia(valor: 12, titulo: "Uber"),
        GastosDia(valor: 26, titulo: "Almoco"),
        GastosDia(valor: 33, titulo: "Jantar"),
        GastosDia(valor: 11, titulo: "Uber")
    ]
}

