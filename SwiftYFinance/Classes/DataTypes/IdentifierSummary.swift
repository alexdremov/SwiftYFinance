//
//  IdentifierSummary.swift
//  IdentifierSummary
//
//  Created by Александр Дремов on 17.06.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct IdentifierSummary {
    public var recommendationTrend:RecommendationTrend?
    public var summaryProfile:SummaryProfile?
    public var quoteType:QuoteType?
    public var price:Price?
    public var indexTrend:IndexTrend?
    
    public var dataStorage:JSON?
    
    init(information:JSON) {
        self.dataStorage = information
        let recomendationData = information["recommendationTrend"]["trend"][0]
        
        if recomendationData.dictionary != nil{
            self.recommendationTrend = RecommendationTrend(
                buy: recomendationData["buy"].int,
                sell: recomendationData["sell"].int,
                hold: recomendationData["hold"].int,
                strongSell: recomendationData["strongSell"].int,
                strongBuy: recomendationData["strongBuy"].int
            )
        }
        
        if information["summaryProfile"].dictionary != nil{
            self.summaryProfile = SummaryProfile(
                country: information["summaryProfile"]["country"].string,
                city: information["summaryProfile"]["city"].string,
                industry: information["summaryProfile"]["industry"].string,
                address1: information["summaryProfile"]["adress1"].string,
                maxAge: information["summaryProfile"]["maxAge"].int,
                zip: information["summaryProfile"]["zip"].string,
                fullTimeEmployees: information["summaryProfile"]["fullTimeEmployees"].int,
                website:  information["summaryProfile"]["website"].string,
                phone: information["summaryProfile"]["phone"].string,
                longBusinessSummary: information["summaryProfile"]["longBusinessSummary"].string,
                sector: information["summaryProfile"]["sector"].string
            )
        }
        
        if information["quoteType"].dictionary != nil{
            self.quoteType = QuoteType(
                exchange: information["quoteType"]["exchange"].string,
                market: information["quoteType"]["market"].string,
                shortName: information["quoteType"]["shortName"].string,
                quoteType: information["quoteType"]["quoteType"].string,
                exchangeTimezoneShortName: information["quoteType"]["exchangeTimezoneShortName"].string,
                exchangeTimezoneName: information["quoteType"]["exchangeTimezoneName"].string,
                longName: information["quoteType"]["longName"].string,
                symbol: information["quoteType"]["symbol"].string
            )
        }
        
        if information["price"].dictionary != nil{
            self.price = Price(
                preMarketTime: information["price"]["preMarketTime"].int,
                exchangeName: information["price"]["exchangeName"].string,
                preMarketChangePercent: information["price"]["preMarketChangePercent"]["raw"].float,
                exchange: information["price"]["exchange"].string,
                currencySymbol:  information["price"]["currencySymbol"].string,
                regularMarketSource:information["price"]["regularMarketSource"].string,
                toCurrency: information["price"]["toCurrency"].string,
                regularMarketChange: information["price"]["regularMarketChange"]["raw"].float,
                exchangeDataDelayedBy: information["price"]["exchangeDataDelayedBy"].int,
                marketCap: information["price"]["marketCap"]["raw"].int,
                regularMarketPrice: information["price"]["regularMarketPrice"]["raw"].float,
                maxAge: information["price"]["maxAge"].int,
                regularMarketChangePercent: information["price"]["regularMarketChangePercent"]["raw"].float,
                currency: information["price"]["currency"].string,
                averageDailyVolume10Day: information["price"]["averageDailyVolume10Day"]["raw"].int,
                marketState: information["price"]["marketState"].string,
                regularMarketDayHigh: information["price"]["regularMarketDayHigh"]["raw"].float,
                regularMarketDayLow: information["price"]["regularMarketDayLow"]["raw"].float,
                longName: information["price"]["longName"].string,
                preMarketPrice: information["price"]["preMarketPrice"]["raw"].float,
                quoteType: information["price"]["quoteType"].string,
                preMarketSource: information["price"]["preMarketSource"].string,
                preMarketChange: information["price"]["preMarketChange"]["raw"].float,
                postMarketChange: information["price"]["postMarketChange"]["raw"].float,
                quoteSourceName: information["price"]["quoteSourceName"].string,
                regularMarketTime: information["price"]["regularMarketTime"].int
            )
        }
        if information["indexTrend"].dictionary != nil{
            var estimates:[IndexTrendEstimates] = []
            
            for est in information["indexTrend"]["estimates"].array!{
                estimates.append(IndexTrendEstimates(period: est["period"].string, growth: est["growth"]["raw"].float))
            }
            
            self.indexTrend = IndexTrend(
                maxAge: information["indexTrend"]["maxAge"].int,
                symbol: information["indexTrend"]["symbol"].string,
                peRatio: information["indexTrend"]["peRatio"]["raw"].float,
                pegRatio: information["indexTrend"]["pegRatio"]["raw"].float,
                estimates: estimates
            )
        }
    }
}

public struct RecommendationTrend{
    public var buy: Int?
    public var sell: Int?
    public var hold: Int?
    public var strongSell:Int?
    public var strongBuy: Int?
}

public struct SummaryProfile{
    public var country : String?
    public var city : String?
    public var industry: String?
    public var address1 : String?
    public var maxAge : Int?
    public var zip : String?
    public var fullTimeEmployees : Int?
    public var website : String?
    public var phone : String?
    public var longBusinessSummary: String?
    public var sector: String?
}

public struct IndexTrend{
    public var maxAge : Int?
    public var symbol : String?
    public var peRatio:Float?
    public var pegRatio:Float?
    public var estimates:[IndexTrendEstimates]?
}

public struct IndexTrendEstimates{
    public var period : String?
    public var growth : Float?
}

public struct SummaryDetail{
    public var maxAge : Int?
    public var priceHint : Int?
    public var previousClose : Float?
    public var open : Float?
    public var dayLow : Float?
    public var dayHigh : Float?
    public var regularMarketPreviousClose : Float?
    public var regularMarketOpen : Float?
    public var regularMarketDayLow : Float?
    public var regularMarketDayHigh : Float?
    public var dividendRate : Float?
    public var dividendYield : Float?
    public var exDividendDate : Float?
    public var payoutRatio : Float?
    public var fiveYearAvgDividendYield : Float?
    public var beta : Float?
    public var trailingPE : Float?
    public var forwardPE : Float?
    public var volume : Float?
    public var regularMarketVolume : Float?
    public var averageVolume : Float?
    public var averageVolume10days : Float?
    public var averageDailyVolume10Day : Float?
    public var bid : Float?
    public var ask : Float?
    public var bidSize : Float?
    public var askSize : Float?
    public var marketCap : Float?
    public var yield : Float?
    public var ytdReturn : Float?
    public var totalAssets : Float?
    public var expireDate : Float?
    public var strikePrice : Float?
    public var openInterest : Float?
    public var fiftyTwoWeekLow : Float?
    public var fiftyTwoWeekHigh : Float?
    public var priceToSalesTrailing12Months : Float?
    public var fiftyDayAverage : Float?
    public var twoHundredDayAverage : Float?
    public var trailingAnnualDividendRate : Float?
    public var trailingAnnualDividendYield : Float?
    public var volume24Hr : Float?
    public var volumeAllCurrencies : Float?
    public var circulatingSupply: Float?
    public var navPrice : Float?
    public var currency : String?
    public var fromCurrency : String?
    public var toCurrency : String?
    public var tradable : Bool?
}

public struct CalendarEvents{
    public var exDividendDate : Int?
    public var dividendDate : Int?
}
