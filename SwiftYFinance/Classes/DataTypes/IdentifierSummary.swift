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
    public var recommendationTrend:StockRecomendations?
    public var profile:IdentifierSummaryProfile?
    public var quoteType:QuoteType?
    public var price:StockPriceInfo?
    
    public var dataStorage:JSON?
    
    init(information:JSON) {
        self.dataStorage = information
        let recomendationData = information["recommendationTrend"]["trend"][0]

        if recomendationData.dictionary != nil{
            self.recommendationTrend = StockRecomendations(
                buy: recomendationData["buy"].int,
                sell: recomendationData["sell"].int,
                hold: recomendationData["hold"].int,
                strongSell: recomendationData["strongSell"].int,
                strongBuy: recomendationData["strongBuy"].int
            )
        }
        
        if information["summaryProfile"].dictionary != nil{
            self.profile = IdentifierSummaryProfile(
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
            self.price = StockPriceInfo(
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
    }
}

public struct StockRecomendations{
    public var buy: Int?
    public var sell: Int?
    public var hold: Int?
    public var strongSell:Int?
    public var strongBuy: Int?
}

public struct IdentifierSummaryProfile{
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
