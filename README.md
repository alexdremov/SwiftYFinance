# SwiftYFinance
<hr></hr>
Refactored <b>v3.0.0</b> with Swift concurrency support is coming!
<hr></hr>

[![codecov](https://img.shields.io/codecov/c/github/AlexRoar/SwiftYFinance)](https://codecov.io/gh/AlexRoar/SwiftYFinance)
[![CodeFactor](https://www.codefactor.io/repository/github/alexroar/swiftyfinance/badge)](https://www.codefactor.io/repository/github/alexroar/swiftyfinance)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/AlexRoar/SwiftYFinance/swift.yml)

## Requirements

I used Swift 5.0 and backward compatibility is not guranteed. IOS 13+

## Installation

SwiftYFinance is available through [Swift Package Manager](https://swift.org/package-manager/).

Add dependency to your Package file:

```swift
dependencies: [
    .package(url: "https://github.com/AlexRoar/SwiftYFinance", .upToNextMajor(from: "1.4.0")),
]
```

Or add dependency to your XCode project: `File` > `Swift Packages` > `Add Package Dependency`

```
https://github.com/AlexRoar/SwiftYFinance
```
## Basic Usage

### Search
```swift
/*
* Main class of SwiftYFinance. Asynchronous method's callback always will
* have format: (Some Data?, Error?). If error is non-nil, then data is going to be nil.
* Review Error description to find out what's wrong.
* Synchronous API is also provided. The only difference is that it blocks the thread and
* returns data rather than passing it to the callback.
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

Search for news is also awailable through `fetchSearchDataBy(searchNews:String, ...)`

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

### Chart data at moment

Sometimes, you need to fetch data at some moment in the past. Use `chartDataBy(..., moment: Date, ...)` for that.

```swift
SwiftYFinance.chartDataBy(
        identifier:"AAPL",
        moment: Date(...),
        futureMargin: TimeInterval(...)
        ){
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

### Identifier Summary

This part of API is MASSIVE. Yahoo Finance has a lot of summary modules and I implemented several of them. Still, you can fetch data from raw JSON parameter.

I will add new modules with every version. Currently, only essential modules are implemented.

| Module                            | Support | Module                            | Support |
|-----------------------------------|---------|-----------------------------------|---------|
| calendarEvents                    | :white_check_mark: | recommendationTrend               | :white_check_mark: |
| summaryProfile                    | :white_check_mark: | quoteType                         | :white_check_mark: |
| industryTrend                     | :white_check_mark: | price                             | :white_check_mark: |
| summaryDetail                     | :white_check_mark: | incomeStatementHistoryQuarterly   | :x: |
| assetProfile                      | :x: | balanceSheetHistoryQuarterly      | :x: |
| incomeStatementHistory            | :x: | cashFlowStatementHistory          | :x: |
| balanceSheetHistory               | :x: | cashFlowStatementHistoryQuarterly | :x: |
| financialData                     | :x: | secFilings                        | :x: |
| upgradeDowngradeHistory           | :x: | institutionOwnership              | :x: |
| fundOwnership                     | :x: | majorDirectHolders                | :x: |
| majorHoldersBreakdown             | :x: | insiderTransactions               | :x: |
| insiderHolders                    | :x: | netSharePurchaseActivity          | :x: |
| sectorTrend                       | :x: | earnings                          | :x: |
| companyOfficers                   | :x: | earningsHistory                   | :x: |
| earningsTrend                     | :x: | indexTrend                        | :x: |
| symbol                            | :x: | fundProfile                       | :x: |
| topHoldings                       | :x: | fundPerformance                   | :x: |
| defaultKeyStatistics              | :x: |                                   |     |

You can fetch modules by calling `summaryDataBy(...)`

```swift
SwiftYFinance.summaryDataBy(identifier: "AAPL", selection = .all){
data, error in
    if error != nil{
        return
    }
    print(data)
    /*
    data ~>
    struct IdentifierSummary {
        var recommendationTrend:RecommendationTrend?
        var summaryProfile:SummaryProfile?
        var quoteType:QuoteType?
        var price:Price?
        var indexTrend:IndexTrend?
        var calendarEvents:CalendarEvents?
        var summaryDetail:SummaryDetail?
        var dataStorage:JSON?
    }
    */

    // Raw JSON:
    print(data.dataStorage)
}
```

Several types of selection are available. `.all` will fetch every method, even not supported yet so that you can get data from raw JSON. You can select `.supported`, then only supported data will be fetched. Also, you can specify specific module (ex: `.price`) or list of modules (ex: `[.price, .summaryDetail]`)

## Author

Aleksandr Dremov, dremov.me@gmail.com

## License

SwiftYFinance is available under the MIT license. See the LICENSE file for more info.
