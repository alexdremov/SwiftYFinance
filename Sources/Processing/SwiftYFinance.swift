//
//  SwiftYFinance.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 11.08.2020.

import Alamofire
import Foundation
import SwiftyJSON

/** Main class of SwiftYFinance. Asynchronous methods' callback always will have format: `Some Data?, Error?`.
 * If error is non-nil, then data is going to be nil. Review Error description to find out what's wrong.
 * Synchronous API is also provided. The only difference is that it blocks the thread and returns data rather than passing it to the callback.
 */
public class SwiftYFinance {
    /**
     For some services,Yahoo requires crumb parameter and cookies.
     The framework fetches it during the first use.
     */
    static var crumb: String = ""
    static var cookies: String = ""

    /**
     The counter of requests. This parameter is added to the urls to change them as, sometimes, caching of content does a bad thing.
     By changing url with this parameter, the app expects uncached response.
     */
    static var cacheCounter: Int = 0

    /**
     The headers to use in all requests
     */
    static var headers: HTTPHeaders = [
        "Accept": "*/*",
        "Pragma": "no-cache",
        "Origin": "https://finance.yahoo.com",
        "Cache-Control": "no-cache",
        "Host": "query1.finance.yahoo.com",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15",
        "Accept-Encoding": "gzip, deflate, br"
    ]

    /**
     Session to use in all requests.
     - Note: it is crucial as without httpShouldSetCookies parameter, sometemes, Yahoo sends invalid cookies that are saved. Then, all consequent requests corrupt.
     */
    static var session: Session = {
        let configuration = Session.default.sessionConfiguration
        //        configuration.waitsForConnectivity = false
        configuration.httpShouldSetCookies = false
        configuration.requestCachePolicy = .reloadIgnoringCacheData

        configuration.httpCookieStorage?.cookieAcceptPolicy = .always

        return Session(configuration: configuration)
    }()

    /**
     Fetches crumb and cookies
     - Note: blocks the thread.
     */
    private class func fetchCredentials() {
        let semaphore = DispatchSemaphore(value: 0)

        //        session
        //            .request("https://guce.yahoo.com/copyConsent")
        //            .response(queue: .global(qos: .userInteractive)) { response in
        //                semaphore.signal()
        //            }
        //
        //        semaphore.wait()

        session
            .request("https://finance.yahoo.com/quote/AAPL/history")
            .response(queue: .global(qos: .userInteractive)) {
                response in
                defer {
                    semaphore.signal()
                }
                
                Self.cookies = response.response?.headers["Set-Cookie"] ?? ""
                if response.data == nil {
                    return
                }

                let data = String(data: response.data!, encoding: .utf8)
                guard let data = data else {
                    return
                }

                let pattern = #""CrumbStore":\{"crumb":"(?<crumb>[^"]+)"\}"#
                let range = NSRange(location: 0, length: data.utf16.count)
                guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
                      let match = regex.firstMatch(in: data, options: [], range: range),
                      let rangeData = Range(match.range, in: data) else {
                    return
                }
                let crumbStr = String(data[rangeData])

                let wI = NSMutableString( string: crumbStr )
                CFStringTransform( wI, nil, "Any-Hex/Java" as NSString, true )
                let decodedStr = wI as String
                Self.crumb = String(decodedStr.suffix(13).prefix(11))
            }

        semaphore.wait()
    }

    /**
     Fetches credentials if they were not set.
     */
    private class func prepareCredentials() {
        if Self.crumb == ""{
            Self.fetchCredentials()
        }
    }

    /**
     Searches quote in Yahoo finances and returns found results
     - Parameters:
     - searchTerm: String to search
     - quotesCount: Maximum found elements to load
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     */
    public class func fetchSearchDataBy(searchTerm: String, quotesCount: Int = 20, queue: DispatchQueue = .main, callback: @escaping ([YFQuoteSearchResult]?, Error?) -> Void) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */
        if searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback([], nil)
            return
        }
        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "quotesCount", value: String(quotesCount)),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        session.request(urlComponents, headers: Self.headers)
            .responseData(queue: queue) { response  in
                if response.error != nil {
                    callback(nil, response.error)
                    return
                }

                var result: [YFQuoteSearchResult] = []
                let json = try! JSON(data: response.value!)

                if nil != json["chart"]["error"]["description"].string {
                    callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                    return
                }
                if nil != json["finance"]["error"]["description"].string {
                    callback(nil, YFinanceResponseError(message: json["finance"]["error"]["description"].string))
                    return
                }

                if json["search"]["error"]["description"].string != nil {
                    callback(nil, YFinanceResponseError(message: json["search"]["error"]["description"].string))
                    return
                }

                if json["quotes"].array == nil {
                    callback(nil, YFinanceResponseError(message: "Empty response"))
                    return
                }

                for found in json["quotes"].array! {
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
    public class func syncFetchSearchDataBy(searchTerm: String, quotesCount: Int = 20) -> ([YFQuoteSearchResult]?, Error?) {
        var retData: [YFQuoteSearchResult]?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.fetchSearchDataBy(searchTerm: searchTerm, quotesCount: quotesCount, queue: DispatchQueue.global(qos: .utility)) {
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
    public class func fetchSearchDataBy(searchNews: String, newsCount: Int = 20, queue: DispatchQueue = .main, callback: @escaping ([YFNewsSearchResult]?, Error?) -> Void) {
        /*
         https://query1.finance.yahoo.com/v1/finance/search
         */

        if searchNews.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback([], nil)
            return
        }

        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchNews),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "newsCount", value: String(newsCount)),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]

        session.request(urlComponents, headers: Self.headers).responseData(queue: queue) { response  in
            if response.error != nil {
                callback(nil, response.error)
                return
            }

            var result: [YFNewsSearchResult] = []
            let json = try! JSON(data: response.value!)

            if json["chart"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["finance"]["error"]["description"].string))
                return
            }
            if json["search"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["search"]["error"]["description"].string))
                return
            }

            for found in json["quotes"].array! {
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
    public class func syncFetchSearchDataBy(searchNews: String, newsCount: Int = 20) -> ([YFNewsSearchResult]?, Error?) {
        var retData: [YFNewsSearchResult]?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.fetchSearchDataBy(searchNews: searchNews, newsCount: newsCount, queue: DispatchQueue.global(qos: .utility)) {
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
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     */
    public class func summaryDataBy(identifier: String, selection: QuoteSummarySelection = .supported, queue: DispatchQueue = .main, callback: @escaping (IdentifierSummary?, Error?) -> Void) {
        summaryDataBy(identifier: identifier, selection: [selection], queue: queue, callback: callback)
    }

    /**
     The same as `SwiftYFinance.summaryDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncSummaryDataBy(identifier: String, selection: QuoteSummarySelection = .supported) -> (IdentifierSummary?, Error?) {
        self.syncSummaryDataBy(identifier: identifier, selection: [selection])
    }

    /**
     Fetches summary information about identifier.
     - Warning: Identifier must exist or data will be nil and error will be setten
     - Parameters:
     - identifier: Name of identifier
     - selection: Which areas of summary to get
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     - TODO: return not JSON but custom type
     */
    public class func summaryDataBy(identifier: String, selection: [QuoteSummarySelection], queue: DispatchQueue = .main, callback: @escaping (IdentifierSummary?, Error?) -> Void) {
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }

        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query2.finance.yahoo.com"
        urlComponents.path = "/v10/finance/quoteSummary/\(identifier)"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "modules", value: selection.map({
                data in
                String(data.rawValue)
            }).joined(separator: ",")),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "includePrePost", value: "true"),
            URLQueryItem(name: "corsDomain", value: "finance.yahoo.com"),
            URLQueryItem(name: ".tsrc", value: "finance"),
            URLQueryItem(name: "symbols", value: identifier),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]

        session.request(urlComponents, headers: Self.headers).responseData(queue: queue) { response in
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            let jsonRaw = try! JSON(data: response.value!)

            if jsonRaw["chart"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: jsonRaw["chart"]["error"]["description"].string))
                return
            }
            if jsonRaw["finance"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: jsonRaw["finance"]["error"]["description"].string))
                return
            }

            if jsonRaw["quoteSummary"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: jsonRaw["quoteSummary"]["error"]["description"].string))
                return
            }

            callback(IdentifierSummary(information: jsonRaw["quoteSummary"]["result"][0]), nil)
        }
    }

    /**
     The same as `SwiftYFinance.summaryDataBy(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncSummaryDataBy(identifier: String, selection: [QuoteSummarySelection]) -> (IdentifierSummary?, Error?) {
        var retData: IdentifierSummary?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.summaryDataBy(identifier: identifier, selection: selection, queue: DispatchQueue.global(qos: .utility)) {
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
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     */
    public class func recentDataBy(identifier: String, queue: DispatchQueue = .main, callback: @escaping (RecentStockData?, Error?) -> Void) {
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }

        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v8/finance/chart/\(identifier)"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "symbols", value: identifier),
            URLQueryItem(name: "symbol", value: identifier),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "includePrePost", value: "false"),
            URLQueryItem(name: "corsDomain", value: "finance.yahoo.com"),
            URLQueryItem(name: "interval", value: "2m"),
            URLQueryItem(name: "range", value: "1d"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: ".tsrc", value: "finance"),
            URLQueryItem(name: "period1", value: String(Int(Date().timeIntervalSince1970))),
            URLQueryItem(name: "period2", value: String(Int(Date().timeIntervalSince1970) + 10)),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]

        session.request(urlComponents, headers: Self.headers).responseData(queue: queue) { response in
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            let json = try! JSON(data: response.value!)

            if json["chart"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil {
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
    public class func syncRecentDataBy(identifier: String) -> (RecentStockData?, Error?) {
        var retData: RecentStockData?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.recentDataBy(identifier: identifier, queue: DispatchQueue.global(qos: .utility)) {
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
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     */
    public class func chartDataBy(identifier: String, start: Date = Date(), end: Date = Date(), interval: ChartTimeInterval = .oneday, queue: DispatchQueue = .main, callback: @escaping ([StockChartData]?, Error?) -> Void) {
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback(nil, YFinanceResponseError(message: "Empty identifier"))
            return
        }

        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v8/finance/chart/\(identifier)"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "symbols", value: identifier),
            URLQueryItem(name: "symbol", value: identifier),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "period1", value: String(Int(start.timeIntervalSince1970))),
            URLQueryItem(name: "period2", value: String(Int(end.timeIntervalSince1970))),
            URLQueryItem(name: "interval", value: interval.rawValue),
            URLQueryItem(name: "includePrePost", value: "true"),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]

        print(try! urlComponents.asURL())

        session.request(urlComponents, headers: Self.headers).responseData(queue: queue) { response in
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            let json = try! JSON(data: response.value!)

            if json["chart"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["chart"]["error"]["description"].string))
                return
            }
            if json["finance"]["error"]["description"].string != nil {
                callback(nil, YFinanceResponseError(message: json["error"].string))
                return
            }

            let fullData = json["chart"]["result"][0].dictionary
            let quote = fullData?["indicators"]?["quote"][0].dictionary
            let adjClose = fullData?["indicators"]?["adjclose"][0]["adjclose"].array
            let timestamps = fullData?["timestamp"]?.array

            var result: [StockChartData] = []

            if timestamps == nil {
                callback([], YFinanceResponseError(message: "Empty chart data"))
                return
            }
            for reading in 0..<timestamps!.count {
                result.append(StockChartData(
                                date: Date(timeIntervalSince1970: Double(timestamps![reading].float!)),
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
    public class func syncChartDataBy(identifier: String, start: Date = Date(), end: Date = Date(), interval: ChartTimeInterval = .oneday) -> ([StockChartData]?, Error?) {
        var retData: [StockChartData]?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.chartDataBy(identifier: identifier, start: start, end: end, interval: interval, queue: DispatchQueue.global(qos: .utility)) {
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
     - moment: moment at witch data will be fetched
     - futureMargin: seconds to margin into the future
     - queue: queue to use for request asyncgtonous processing
     - queue: queue to use for request asyncgtonous processing
     - callback: callback, two parameters will be passed
     */
    public class func recentChartDataAtMoment(identifier: String, moment: Date = Date(), futureMargin: TimeInterval = 0, queue: DispatchQueue = .main, callback: @escaping (StockChartData?, Error?) -> Void) {
        let momentWithMargin = Date(timeIntervalSince1970: moment.timeIntervalSince1970 + futureMargin)
        self.chartDataBy(identifier: identifier, start: Date(timeIntervalSince1970: momentWithMargin.timeIntervalSince1970 - 7 * 24 * 60 * 60 + futureMargin), end: momentWithMargin, interval: .oneminute, queue: queue) {
            dataLet, errorLet in

            var data = dataLet
            var error = errorLet

            if data == nil {
                (data, error) = self.syncChartDataBy(identifier: identifier, start: Date(timeIntervalSince1970: momentWithMargin.timeIntervalSince1970 - 7 * 24 * 60 * 60 + futureMargin), end: momentWithMargin, interval: .oneday)
            }

            if data == nil {
                callback(nil, error)
            } else {
                if data!.isEmpty {
                    callback(nil, YFinanceResponseError(message: "No data found at this(\(moment)) moment"))
                    return
                }
                var i = data!.count - 1
                var selectedForReturn: StockChartData = data![data!.count - 1]
                while selectedForReturn.close == nil && selectedForReturn.open == nil && i > 0 {
                    i -= 1
                    selectedForReturn = data![i]
                }
                callback(selectedForReturn, error)
            }
        }
    }

    /**
     The same as `SwiftYFinance.recentChartDataAtMoment(...)` except that it executes synchronously and returns data rather than giving it to the callback.
     */
    public class func syncRecentChartDataAtMoment(identifier: String, moment: Date = Date(), futureMargin: TimeInterval = 0) -> (StockChartData?, Error?) {
        var retData: StockChartData?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.recentChartDataAtMoment(identifier: identifier, moment: moment, futureMargin: futureMargin, queue: DispatchQueue.global(qos: .utility)) {
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
