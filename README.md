# SwiftYFinance

[![Language](https://img.shields.io/github/languages/top/AlexRoar/SwiftYFinance)](https://cocoapods.org/pods/SwiftYFinance)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/AlexRoar/SwiftYFinance/Swift)](https://cocoapods.org/pods/SwiftYFinance)
[![Version](https://img.shields.io/cocoapods/v/SwiftYFinance.svg?style=flat)](https://cocoapods.org/pods/SwiftYFinance)
[![License](https://img.shields.io/cocoapods/l/SwiftYFinance.svg?style=flat)](https://cocoapods.org/pods/SwiftYFinance)
[![Platform](https://img.shields.io/cocoapods/p/SwiftYFinance.svg?style=flat)](https://cocoapods.org/pods/SwiftYFinance)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Example project includes basic features demonstration.

<img src="https://i.ibb.co/j8VVg3D/smartmockups-kdsmv8zx.png" alt="" height="350px"><img src="https://i.ibb.co/frQphbY/smartmockups-kdsmw7gq.png" alt="" height="350px">

## Basic Usage

### Search
```swift
/*
* Main class of SwiftYFinance. Asynchronous methods' callback always will have  format: (Some Data?, Error?). If error is non-nil, then data is going to be nil. Review Error description to find out what's wrong.
* Synchronous API is also provided. The only difference is that it blocks the thread and returns data rather than passing it to the callback.
*/
import SwiftYFinance

// Searches quote in Yahoo finances and returns found results
SwiftYFinance.fetchSearchDataBy(searchTerm:"AAPL", quotesCount=20) {
    data, error in
    /*
    callback: ([YFQuoteSearchResult]?, Error?) -> Void
    struct YFQuoteSearchResult{
        var symbol: String?
        var shortname: String?
        var longname: String?
        var exchange: String?
        var assetType: String?
    }
    */
    if error == nil{
        return 
    }
    print(data!.longname ?? "No long name")
}
```

The same thing but synchronously:

```swift
let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm:"AAPL", quotesCount=20)
if error == nil{
    return 
}
print(data!.longname ?? "No long name")
```

**Even though executing commands in the main thread synchronously is not the best practice, I added this feature to the project. It's on your account to write fast, non-freezing apps, so use synchronous methods wisely.**

### Basic recent data

Fetches the most recent data about identifier collecting basic information.
```swift
SwiftYFinance.recentDataBy(identifier:"AAPL"){
    data, error in
    /*
    data ~>
    struct RecentStockData{
        var currency: String?
        var symbol: String?
        var exchangeName: String?
        var instrumentType: String?
        var firstTradeDate: Int?
        var regularMarketTime: Int?
        var gmtoffset: Int?
        var timezone: String?
        var exchangeTimezoneName: String?
        var regularMarketPrice: Float?
        var chartPreviousClose: Float?
        var previousClose: Float?
        var scale: Int?
        var priceHint: Int?
    }
    */
    if error == nil{
        return 
    }
    print(data!.regularMarketPrice ?? "No regularMarketPrice")
}
```

### Chart data

Fetches chart data points
```swift
SwiftYFinance.chartDataBy(
        identifier:"AAPL",
        start: Date(...),
        end: Date(...),
        interval = .oneday){
    data, error in
    /*
    data ~>[
        struct StockChartData{
            var date: Date?
            var volume: Int?
            var open: Float?
            var close: Float?
            var adjclose: Float?
            var low: Float?
            var high: Float?
        }
    ]
    */
    if error == nil{
        return 
    }
    print(data![0]?.open ?? "Open price is unavailable")
}
```

### Big summary

```

```

## Requirements

I used Swift 5.0 and backward compatibility is not guranteed. IOS 13+

## Installation

SwiftYFinance is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftYFinance'
```

## Author

Aleksandr Dremov, dremov.me@gmail.com

## License

SwiftYFinance is available under the MIT license. See the LICENSE file for more info.
