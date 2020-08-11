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
            let json = try! JSON(data: response.value!!)
            debugPrint(json)
        }
    }
    
    public class  func fetchSearchDataBy(searchNews:String, callbask: @escaping ([YFNewsSearchResult])->Void, quotesCount:Int = 20) throws {
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
            URLQueryItem(name: "quotesCount", value: String(quotesCount))
        ]

        let requestURL = urlComponents.url?.absoluteString
        if requestURL == nil{
            throw URLGenerationError()
        }
        
        AF.request(requestURL!).response(){ response  in
            let json = try! JSON(data: response.value!!)
            debugPrint(json)
        }
    }
}

