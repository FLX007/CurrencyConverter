//
//  model.swift
//  CurrencyConverter
//
//  Created by FR on 28.11.2021.
//

import Foundation
struct Exchange: Decodable {
    let base: String
    let rates: ExchangeRates
}

struct ExchangeRates: Decodable {
    let EUR: Double
    let RUB: Double
    let GBP: Double
    let CNY: Double
}
