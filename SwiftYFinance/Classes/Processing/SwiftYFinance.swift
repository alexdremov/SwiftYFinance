//
//  SwiftYFinance.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 11.08.2020.
//

import Foundation
import SwiftyJSON
import Alamofire
/** Main class of SwiftYFinance. Asynchronous methods' callback always will have  format: `Some Data?, Error?`. If error is non-nil, then data is going to be nil. Review Error description to find out what's wrong.
 * Synchronous API is also provided. The only difference is that it blocks the thread and returns data rather than passing it to the callback.
 */
public class SwiftYFinance{
    /**
     Searches quote in Yahoo finances and returns found results
     - Parameters:
     - searchTerm: String to search
     - quotesCount: Maximum found elements to load
     - callback: Callback, two parameters will be passed
     */
    public class func fetchSearchDataBy(searchTerm:String, quotesCount:Int = 20, callback: @escaping ([YFQuoteSearchResult]?, Error?)->Void) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */
        if searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback([], nil)
            return
        }
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
        
        
        AF.request(requestURL!).responseData(queue:DispatchQueue.global(qos: .utility)){ response  in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            
            var result:[YFQuoteSearchResult] = []
            let json = try! JSON(data: response.value!)
            
            if let _ = json["chart"]["error"]["description"].string{
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if let _ = json["finance"]["error"]["description"].string{
                callback(nil, YFinanceResponseError(message: json["finance"]["error"]["description"].string))
                return
            }
            
            if json["search"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["search"]["error"]["description"].string))
                return
            }
            
            if (json["quotes"].array == nil){
                callback(nil, YFinanceResponseError(message: "Empty response"))
                return
            }
            
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
    
    /**
     The same as `SwiftYFinance.fetchSearchDataBy` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncFetchSearchDataBy(searchTerm:String, quotesCount:Int = 20) -> ([YFQuoteSearchResult]?, Error?) {
        var retData:[YFQuoteSearchResult]?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.fetchSearchDataBy(searchTerm: searchTerm, quotesCount:quotesCount){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
        }
        
        semaphore.wait()
        return (retData, retError)
    }
    
    /**
     The same as `SwiftYFinance.fetchSearchDataBy` except that it searches for news
     */
    public class func fetchSearchDataBy(searchNews:String, newsCount:Int = 20, callback: @escaping ([YFNewsSearchResult]?,  Error?)->Void) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */
        
        if searchNews.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback([], nil)
            return
        }
        
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
        
        AF.request(requestURL!).responseData(queue:DispatchQueue.global(qos: .utility)){ response  in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            
            var result:[YFNewsSearchResult] = []
            let json = try! JSON(data: response.value!)
            
            if json["chart"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["finance"]["error"]["description"].string))
                return
            }
            if json["search"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: json["search"]["error"]["description"].string))
                return
            }
            
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
    
    /**
     The same as `SwiftYFinance.fetchSearchDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncFetchSearchDataBy(searchNews:String, newsCount:Int = 20) -> ([YFNewsSearchResult]?, Error?) {
        var retData:[YFNewsSearchResult]?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.fetchSearchDataBy(searchNews: searchNews, newsCount:newsCount){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
            
            
        }
        semaphore.wait()
        return (retData, retError)
    }
    
    /**
     Fetches summary information about identifier.
     - Warning: Identifier must exist or data will be nil and error will be setten
     - Parameters:
     - identifier: Name of identifier
     - selection: Which area of summary to get
     */
    public class func summaryDataBy(identifier:String,   selection:QuoteSummarySelection = .supported, callback: @escaping (IdentifierSummary?, Error?)->Void) {
        summaryDataBy(identifier:identifier, selection:[selection], callback: callback)
    }
    
    /**
     The same as `SwiftYFinance.summaryDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncSummaryDataBy(identifier:String, selection:QuoteSummarySelection = .supported) ->  (IdentifierSummary?, Error?){
        return self.syncSummaryDataBy(identifier:identifier, selection:[selection])
    }
    
    /**
     Fetches summary information about identifier.
     - Warning: Identifier must exist or data will be nil and error will be setten
     - Parameters:
     - identifier: Name of identifier
     - selection: Which areas of summary to get
     - TODO: return not JSON but custom type
     */
    public class func summaryDataBy(identifier:String, selection:[QuoteSummarySelection],  callback: @escaping (IdentifierSummary?, Error?)->Void){
        
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }
        
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
        
        AF.request(requestURL!).responseData(queue:DispatchQueue.global(qos: .utility)){ response in
            if (response.error != nil){
                callback(nil, response.error)
                return
            }
            let jsonRaw = try! JSON(data: response.value!)
            
            if jsonRaw["chart"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: jsonRaw["chart"]["error"]["description"].string))
                return
            }
            if jsonRaw["finance"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: jsonRaw["finance"]["error"]["description"].string))
                return
            }
            
            if jsonRaw["quoteSummary"]["error"]["description"].string != nil{
                callback(nil, YFinanceResponseError(message: jsonRaw["quoteSummary"]["error"]["description"].string))
                return
            }
            
            callback(IdentifierSummary(information: jsonRaw["quoteSummary"]["result"][0]), nil)
        }
    }
    
    /**
     The same as `SwiftYFinance.summaryDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncSummaryDataBy(identifier:String, selection:[QuoteSummarySelection]) ->  (IdentifierSummary?, Error?){
        var retData: IdentifierSummary?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.summaryDataBy(identifier: identifier, selection:selection){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
        }
        
        semaphore.wait()
        return (retData, retError)
    }
    
    /**
     Fetches the most recent data about identifier collecting basic information.
     - Warning: Identifier must exist or data will be nil and error will be setten
     - Parameters:
     - identifier: Name of identifier
     */
    public class func recentDataBy(identifier:String, callback: @escaping (RecentStockData?, Error?)->Void){
        
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }
        
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
        
        AF.request(requestURL!).responseData(queue:DispatchQueue.global(qos: .utility)){ response in
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
    
    /**
     The same as `SwiftYFinance.recentDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncRecentDataBy(identifier:String)->(RecentStockData?, Error?){
        var retData:RecentStockData?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.recentDataBy(identifier: identifier){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
            
        }
        semaphore.wait()
        return (retData, retError)
    }
    
    /**
     Fetches chart data points
     - Warning:
     * Identifier must exist or data will be nil and error will be setten
     * When you select minute – day interval, you can't get historicaly old points. Select oneday interval if you want to fetch maximum available number of points.
     - Parameters:
     - identifier: Name of identifier
     - start: `Date` type start of points retrieve
     - end: `Date` type end of points retrieve
     - interval: interval between points
     */
    public class func chartDataBy(identifier:String, start:Date=Date(), end:Date=Date(), interval:ChartTimeInterval = .oneday, callback: @escaping ([StockChartData]?, Error?)->Void){
        
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }
        
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
        AF.request(requestURL!).responseData(queue:DispatchQueue.global(qos: .utility)){ response in
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
            
            let fullData = json["chart"]["result"][0].dictionary
            let quote = fullData?["indicators"]?["quote"][0].dictionary
            let adjClose = fullData?["indicators"]?["adjclose"][0]["adjclose"].array
            let timestamps = fullData?["timestamp"]?.array
            
            var result:[StockChartData] = [];
            
            if timestamps == nil{
                callback([], YFinanceResponseError(message: "Empty chart data"))
                return 
            }
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
    
    /**
     The same as `SwiftYFinance.chartDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncChartDataBy(identifier:String, start:Date=Date(), end:Date=Date(), interval:ChartTimeInterval = .oneday) -> ([StockChartData]?, Error?){
        var retData:[StockChartData]?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.chartDataBy(identifier:identifier, start:start, end:end, interval:interval){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
            
        }
        semaphore.wait()
        return (retData, retError)
    }
    
    
    /**
     Fetches chart data at moment or the closest one from the past.
     - Warning: Identifier must exist or data will be nil and error will be setten
     - Parameters:
     - identifier: Name of identifier
     - moment: `Date` type moment
     */
    public class func recentChartDataAtMoment(identifier:String, moment:Date=Date(), callback: @escaping (StockChartData?, Error?)->Void){
        self.chartDataBy(identifier: identifier, start: Date(timeIntervalSince1970: moment.timeIntervalSince1970 - 7 * 24 * 60 * 60), end: moment, interval: .oneminute){
            data, error in
            if data == nil{
                callback(nil, error)
            }else{
                if (data!.count == 0){
                    callback(nil, YFinanceResponseError(message: "No data found at this(\(moment)) moment"))
                    return
                }
                callback(data![data!.count - 1], error)
            }
        }
    }
    
    /**
     The same as `SwiftYFinance.recentChartDataAtMoment(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncRecentChartDataAtMoment(identifier:String, moment:Date=Date()) -> (StockChartData?, Error?){
        var retData:StockChartData?, retError:Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.recentChartDataAtMoment(identifier:identifier, moment:moment){
            data, error in
            defer {
                semaphore.signal()
            }
            retData = data
            retError = error
            
        }
        
        semaphore.wait()
        return (retData, retError)
    }
}

