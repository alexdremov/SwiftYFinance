//
//  File.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 13.08.2020.
//

import Foundation

public struct SummaryDetail {
    public var maxAge: Int?
    public var priceHint: Int?
    public var previousClose: Float?
    public var open: Float?
    public var dayLow: Float?
    public var dayHigh: Float?
    public var regularMarketPreviousClose: Float?
    public var regularMarketOpen: Float?
    public var regularMarketDayLow: Float?
    public var regularMarketDayHigh: Float?
    public var dividendRate: Float?
    public var dividendYield: Float?
    public var exDividendDate: Float?
    public var payoutRatio: Float?
    public var fiveYearAvgDividendYield: Float?
    public var beta: Float?
    public var trailingPE: Float?
    public var forwardPE: Float?
    public var volume: Float?
    public var regularMarketVolume: Float?
    public var averageVolume: Float?
    public var averageVolume10days: Float?
    public var averageDailyVolume10Day: Float?
    public var bid: Float?
    public var ask: Float?
    public var bidSize: Float?
    public var askSize: Float?
    public var marketCap: Float?
    public var yield: Float?
    public var ytdReturn: Float?
    public var totalAssets: Float?
    public var expireDate: Float?
    public var strikePrice: Float?
    public var openInterest: Float?
    public var fiftyTwoWeekLow: Float?
    public var fiftyTwoWeekHigh: Float?
    public var priceToSalesTrailing12Months: Float?
    public var fiftyDayAverage: Float?
    public var twoHundredDayAverage: Float?
    public var trailingAnnualDividendRate: Float?
    public var trailingAnnualDividendYield: Float?
    public var volume24Hr: Float?
    public var volumeAllCurrencies: Float?
    public var circulatingSupply: Float?
    public var navPrice: Float?
    public var currency: String?
    public var fromCurrency: String?
    public var toCurrency: String?
    public var tradable: Bool?
}
