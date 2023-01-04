//
//  QuoteType.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 12.08.2020.
//

import Foundation

public struct QuoteType {
    public var exchange: String?
    public var quoteType: String?
    public var symbol: String?
    public var underlyingSymbol: String?
    public var shortName: String?
    public var longName: String?
    public var firstTradeDateEpochUtc: Int?
    public var timeZoneFullName: String?
    public var timeZoneShortName: String?
    public var uuid: String?
}
