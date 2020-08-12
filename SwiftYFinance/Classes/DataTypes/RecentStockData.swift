//
//  RecentStockData.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 12.08.2020.
//

import Foundation

public struct RecentStockData{
    var currency: String?
    var symbol: String?
    var exchangeName: String?
    var instrumentType: String?
    var firstTradeDate: Int?
    var regularMarketTime: Int?
    var gmtoffset: Int?
    var timezone: String?
    var exchangeTimezoneName: String?
    var regularMarketPrice: Float?
    var chartPreviousClose: Float?
    var previousClose: Float?
    var scale: Int?
    var priceHint: Int?
}
