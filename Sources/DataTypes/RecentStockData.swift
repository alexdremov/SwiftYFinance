//
//  RecentStockData.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 12.08.2020.
//

import Foundation

public struct RecentStockData {
    public var currency: String?
    public var symbol: String?
    public var exchangeName: String?
    public var instrumentType: String?
    public var firstTradeDate: Int?
    public var regularMarketTime: Int?
    public var gmtoffset: Int?
    public var timezone: String?
    public var exchangeTimezoneName: String?
    public var regularMarketPrice: Float?
    public var chartPreviousClose: Float?
    public var previousClose: Float?
    public var scale: Int?
    public var priceHint: Int?
}
