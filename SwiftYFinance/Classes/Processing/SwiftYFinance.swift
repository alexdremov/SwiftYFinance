//
//  SwiftYFinance.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 11.08.2020.
//

import Foundation
import SwiftyJSON
import Alamofire

public class SwiftYFinance{
    public class  func fetchSearchDataBy(searchTerm:String, callback: @escaping ([YFQuoteSearchResult]?, Error?)->Void, quotesCount:Int = 20) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "quotesCount", value: String(quotesCount))
        ]
        
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        
        AF.request(requestURL!).response(){ response  in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            var result:[YFQuoteSearchResult] = []
            let json = try! JSON(data: response.value!!)
            for found in json["quotes"].array!{
                result.append(YFQuoteSearchResult(
                    symbol: found["symbol"].string,
                    shortname: found["shortname"].string,
                    longname: found["longname"].string,
                    exchange: found["exchange"].string,
                    assetType: found["typeDisp"].string
                ))
            }
            callback(result, nil)
        }
    }
    
    public class func fetchSearchDataBy(searchNews:String, callback: @escaping ([YFNewsSearchResult]?,  Error?)->Void, newsCount:Int = 20) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchNews),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "newsCount", value: String(newsCount))
        ]
        
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        
        AF.request(requestURL!).response(){ response  in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            
            var result:[YFNewsSearchResult] = []
            let json = try! JSON(data: response.value!!)
            for found in json["quotes"].array!{
                result.append(YFNewsSearchResult(
                    type: found["type"].string,
                    uuid: found["uuid"].string,
                    link: found["link"].string,
                    title: found["title"].string,
                    publisher: found["publisher"].string,
                    providerPublishTime: found["providerPublishTime"].string)
                )
            }
            callback(result, nil)
        }
    }
    
    public class func summaryDataBy(identifier:String,   selection:QuoteSummarySelection = .financialData, callback: @escaping ([JSON]?, Error?)->Void) {
        summaryDataBy(identifier:identifier, selection:[selection], callback: callback)
    }
    
    public class func summaryDataBy(identifier:String, selection:[QuoteSummarySelection],  callback: @escaping ([JSON]?, Error?)->Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v10/finance/quoteSummary/\(identifier)"
        urlComponents.queryItems = [
            URLQueryItem(name: "modules", value: selection.map({
                data in
                return String(data.rawValue)
            }).joined(separator: ","))
        ]
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        
        AF.request(requestURL!).responseData(){ response in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            let json = try! JSON(data: response.value!)["quoteSummary"]["result"].array
            callback(json, nil)
        }
    }
    
    public class func recentDataBy(identifier:String, callback: @escaping (RecentStockData?, Error?)->Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v8/finance/chart/\(identifier)"
        urlComponents.queryItems = [
            URLQueryItem(name: "symbol", value: identifier),
            URLQueryItem(name: "period1", value: String(Int(Date().timeIntervalSince1970))),
            URLQueryItem(name: "period2", value: String(Int(Date().timeIntervalSince1970)+10))
        ]
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        
        AF.request(requestURL!).responseData(){ response in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            let json = try! JSON(data: response.value!)
            
            if json["chart"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["error"].string))
                return
            }
            
            let metadata = json["chart"]["result"][0]["meta"].dictionary
            
            callback(RecentStockData(
                currency: metadata?["currency"]?.string,
                symbol: metadata?["symbol"]?.string,
                exchangeName: metadata?["exchangeName"]?.string,
                instrumentType: metadata?["instrumentType"]?.string,
                firstTradeDate: metadata?["firstTradeDate"]?.int,
                regularMarketTime: metadata?["regularMarketTime"]?.int,
                gmtoffset: metadata?["gmtoffset"]?.int,
                timezone: metadata?["timezone"]?.string,
                exchangeTimezoneName: metadata?["exchangeTimezoneName"]?.string,
                regularMarketPrice: metadata?["regularMarketPrice"]?.float,
                chartPreviousClose: metadata?["chartPreviousClose"]?.float,
                previousClose: metadata?["previousClose"]?.float,
                scale: metadata?["scale"]?.int,
                priceHint: metadata?["priceHint"]?.int
            ), nil)
        }
    }
    
    public class func chartDataBy(identifier:String, callback: @escaping ([StockChartData]?, Error?)->Void, start:Date=Date(), end:Date=Date(), interval:ChartTimeInterval = .oneday){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v8/finance/chart/\(identifier)"
        urlComponents.queryItems = [
            URLQueryItem(name: "symbol", value: identifier),
            URLQueryItem(name: "period1", value: String(Int(start.timeIntervalSince1970))),
            URLQueryItem(name: "period2", value: String(Int(end.timeIntervalSince1970))),
            URLQueryItem(name: "interval", value: interval.rawValue),
            URLQueryItem(name: "includePrePost", value: "true")
        ]
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        AF.request(requestURL!).responseData(){ response in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            let json = try! JSON(data: response.value!)
            
            if json["chart"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["error"].string))
                return
            }
            
            let fullData = json["chart"]["result"][0].dictionary!
            let quote = fullData["indicators"]?["quote"][0].dictionary!
            let adjClose = fullData["indicators"]?["adjclose"][0]["adjclose"].array!
            let timestamps = fullData["timestamp"]?.array
            
            var result:[StockChartData] = [];
            
            
            for reading in 0..<timestamps!.count{
                result.append(StockChartData(
                    date: Date.init(timeIntervalSince1970: Double(timestamps![reading].float!)),
                    volume: quote?["volume"]?[reading].int,
                    open: quote?["open"]?[reading].float,
                    close: quote?["close"]?[reading].float,
                    adjclose: adjClose?[reading].float,
                    low: quote?["low"]?[reading].float,
                    high: quote?["high"]?[reading].float)
                )
            }
            callback(result, nil)
        }
    }
    
    public class func getBigSummaryOfEquityBy(identifier:String, callback: @escaping (IdentifierEquitySummary?, Error?)->Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "finance.yahoo.com"
        urlComponents.path = "/quote/\(identifier)"
        urlComponents.queryItems = []
        
        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            callback(nil, URLGenerationError())
            return
        }
        
        AF.request(requestURL!).responseString(){ response in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            var html = ""
            if let responseString = response.value{
                html = responseString
                if !(html.contains("QuoteSummaryStore")) {
                    callback(nil, YFinanceResponseError(message: "Scrape for identifier \(identifier) is not available"))
                    return
                }
            }else{
                callback(nil, YFinanceResponseError(message: "Scrape for identifier \(identifier) is not available"))
                return
            }
            
            let jsonStr = html.components(separatedBy: "root.App.main =")[1]
                .components(separatedBy: "(this)")[0]
                .components(separatedBy: ";\n}")[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let jsonObject = JSON(parseJSON: jsonStr)
            
            let jsonSummary = jsonObject["context"]["dispatcher"]["stores"]["QuoteSummaryStore"]
            
            if let type = jsonSummary["quoteType"]["quoteType"].string{
                if type.lowercased() != "equity"{
                    callback(nil, YFinanceResponseError(message: "Scrape for identifier \(identifier) is not of EQUITY type. If you scrape currency, consider another method"))
                    return
                }
            }else{
                callback(nil, YFinanceResponseError(message: "Scrape for identifier \(identifier) has undefined quoteType"))
                return
            }
            debugPrint(requestURL!)
            callback(IdentifierEquitySummary(information: jsonSummary), nil)
        }
    }
}

