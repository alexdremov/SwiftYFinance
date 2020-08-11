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
    public class  func fetchSearchDataBy(searchTerm:String, callbask: @escaping ([YFQuoteSearchResult])->Void, quotesCount:Int = 20) throws {
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
            throw URLGenerationError()
        }
        
        AF.request(requestURL!).response(){ response  in
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
            callbask(result)
        }
    }
    
    public class func fetchSearchDataBy(searchNews:String, callbask: @escaping ([YFNewsSearchResult])->Void, newsCount:Int = 20) throws {
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
            throw URLGenerationError()
        }
        
        AF.request(requestURL!).response(){ response  in
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
            callbask(result)
        }
    }
    
    public class func summaryDataBy(identifier:String,   selection:QuoteSummarySelection = .financialData, callbask: @escaping (JSON?)->Void) throws {
        try summaryDataBy(identifier:identifier, selection:[selection], callbask: callbask)
    }
    
    public class func summaryDataBy(identifier:String, selection:[QuoteSummarySelection],  callbask: @escaping (JSON?)->Void) throws {
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
            throw URLGenerationError()
        }
        
        AF.request(requestURL!).response(){ response  in
            let json = try! JSON(data: response.value!!)["quoteSummary"]["result"].array
            callbask(json)
        }
        
    }
}

