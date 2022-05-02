//
//  SheetView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import BeautyChart
import SwiftUI
import SwiftYFinance

struct SheetView: View {
    @State var chartPoints: [Double] = []
    var points: [CGPoint] {
        var i = -1
        return chartPoints.map { el -> CGPoint in i += 1; return CGPoint(x: CGFloat(i), y: CGFloat(el)) }
    }
    @State var interval: ChartTimeInterval = .oneday
    var selection: SelectedSymbolWrapper?
    @State var identifierSummary: IdentifierSummary?
    var body: some View {
        var style = LineViewStyle().mode2()
        style.lightTheme.bezierStepMode = false
        style.darkTheme.bezierStepMode = false
        return VStack {
            HStack(alignment: .center) {
                Spacer()
                VStack(spacing: 0) {
                    Image(systemName: "line.horizontal.3")
                    Text("pull down to close") .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
            }.padding(.bottom, 5)

            ScrollView(.vertical) {
                VStack {
                    Group {
                        Group {
                            HStack {
                                Text(selection?.symbol ?? "No Symbol")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .padding([.top, .leading, .trailing])
                                Spacer()
                            }
                            VStack {
                                ChartSmoothView(points: points, style: style).padding()
                                HStack {
                                    Button(action: {
                                        self.interval = ChartTimeInterval.oneminute
                                        self.fetchChart()
                                    }) {
                                        Text("1m").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.fiveminutes
                                        self.fetchChart()
                                    }) {
                                        Text("5m").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.thirtyminutes
                                        self.fetchChart()
                                    }) {
                                        Text("30m").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.onehour
                                        self.fetchChart()
                                    }) {
                                        Text("1h").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.oneday
                                        self.fetchChart()
                                    }) {
                                        Text("1d").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.fivedays
                                        self.fetchChart()
                                    }) {
                                        Text("5d").frame(maxWidth: .infinity)
                                    }
                                    Button(action: {
                                        self.interval = ChartTimeInterval.onemonths
                                        self.fetchChart()
                                    }) {
                                        Text("1mo").frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                        /*
                         *
                         Recomendation Trend
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.recommendationTrend").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.recommendationTrend?.buy), desc: "buy")
                            NumberDescView(number: getStringValue(self.identifierSummary?.recommendationTrend?.hold), desc: "hold")
                            NumberDescView(number: getStringValue(self.identifierSummary?.recommendationTrend?.sell), desc: "sell")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.recommendationTrend?.strongBuy), desc: "strongBuy")
                            NumberDescView(number: getStringValue(self.identifierSummary?.recommendationTrend?.strongSell), desc: "strongSell")
                        }
                        /*
                         *
                         Summary Profile
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.summaryProfile").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.country), desc: "country")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.city), desc: "city")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.industry), desc: "industry")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.address1), desc: "address1")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.zip), desc: "zip")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.fullTimeEmployees), desc: "fullTimeEmployees")
                        }

                        NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.website), desc: "website")

                        NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.phone), desc: "phone")
                    }
                    Group {
                        NumberDescView(number: getStringValue(self.identifierSummary?.summaryProfile?.sector), desc: "sector")

                        VStack(alignment: .leading) {
                            Text("Summary:")
                            Text(getStringValue(self.identifierSummary?.summaryProfile?.longBusinessSummary))
                        }.padding()
                        /*
                         *
                         Quote Type
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.quoteType").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.exchange), desc: "exchange")
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.quoteType), desc: "quoteType")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.symbol), desc: "symbol")
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.underlyingSymbol), desc: "underlyingSymbol")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.shortName), desc: "shortName")
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.longName), desc: "longName")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.firstTradeDateEpochUtc), desc: "firstTradeDateEpochUtc")
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.timeZoneFullName), desc: "timeZoneFullName")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.timeZoneShortName ), desc: "timeZoneShortName")
                            NumberDescView(number: getStringValue(self.identifierSummary?.quoteType?.uuid), desc: "uuid")
                        }
                        /*
                         *
                         Price
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.price").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.preMarketTime), desc: "preMarketTime")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.exchangeName), desc: "exchangeName")
                        }
                    }
                    Group {
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.preMarketChangePercent), desc: "preMarketChangePercent")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.currencySymbol), desc: "currencySymbol")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketSource), desc: "regularMarketSource")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.toCurrency), desc: "toCurrency")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketChange), desc: "regularMarketChange")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.exchangeDataDelayedBy), desc: "exchangeDataDelayedBy")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.marketCap), desc: "marketCap")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketPrice), desc: "regularMarketPrice")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.maxAge), desc: "maxAge")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketChangePercent), desc: "regularMarketChangePercent")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.currency ), desc: "currency")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.averageDailyVolume10Day), desc: "averageDailyVolume10Day")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.marketState ), desc: "marketState")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketDayHigh), desc: "regularMarketDayHigh")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.longName), desc: "longName")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketDayLow), desc: "regularMarketDayLow")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.quoteType), desc: "quoteType")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.preMarketPrice), desc: "preMarketPrice")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.preMarketSource ), desc: "preMarketSource")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.preMarketChange), desc: "preMarketChange")
                        }
                    }
                    Group {
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.quoteSourceName), desc: "quoteSourceName")
                            NumberDescView(number: getStringValue(self.identifierSummary?.price?.regularMarketTime), desc: "regularMarketTime")
                        }
                        /*
                         *
                         Calendar Events
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.calendarEvents").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.calendarEvents?.exDividendDate), desc: "exDividendDate")
                            NumberDescView(number: getStringValue(self.identifierSummary?.calendarEvents?.dividendDate), desc: "dividendDate")
                        }
                        /*
                         *
                         Index Trend
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.indexTrend").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.indexTrend?.maxAge), desc: "maxAge")
                            NumberDescView(number: getStringValue(self.identifierSummary?.indexTrend?.symbol), desc: "symbol")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.indexTrend?.peRatio), desc: "peRatio")
                            NumberDescView(number: getStringValue(self.identifierSummary?.indexTrend?.pegRatio), desc: "pegRatio")
                        }
                        /*
                         *
                         Summary Detail
                         *
                         */
                        HStack {
                            Text("IdentifierSummary\n.summaryDetail").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.maxAge), desc: "maxAge")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.priceHint), desc: "priceHint")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.previousClose), desc: "previousClose")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.open), desc: "open")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.dayLow), desc: "dayLow")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.dayHigh), desc: "dayHigh")
                        }
                    }
                    Group {
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.regularMarketPreviousClose), desc: "regularMarketPreviousClose")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.regularMarketOpen), desc: "regularMarketOpen")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.regularMarketDayLow), desc: "regularMarketDayLow")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.regularMarketDayHigh), desc: "regularMarketDayHigh")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.dividendRate), desc: "dividendRate")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.dividendYield), desc: "dividendYield")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.exDividendDate), desc: "exDividendDate")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.payoutRatio), desc: "payoutRatio")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.fiveYearAvgDividendYield), desc: "fiveYearAvgDividendYield")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.beta), desc: "beta")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.trailingPE), desc: "trailingPE")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.forwardPE), desc: "forwardPE")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.volume), desc: "volume")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.regularMarketVolume), desc: "regularMarketVolume")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.averageVolume), desc: "averageVolume")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.averageVolume10days), desc: "averageVolume10days")
                        }
                        HStack(alignment: .center) {
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.averageDailyVolume10Day), desc: "averageDailyVolume10Day")
                            NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.bid), desc: "bid")
                        }
                        Group {
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.askSize), desc: "askSize")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.bidSize), desc: "bidSize")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.marketCap), desc: "marketCap")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.yield), desc: "yield")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.ytdReturn), desc: "ytdReturn")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.totalAssets), desc: "totalAssets")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.expireDate), desc: "expireDate")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.strikePrice), desc: "strikePrice")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.openInterest), desc: "openInterest")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.fiftyTwoWeekLow), desc: "fiftyTwoWeekLow")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.fiftyTwoWeekHigh), desc: "fiftyTwoWeekHigh")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.priceToSalesTrailing12Months), desc: "priceToSalesTrailing12Months")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.fiftyDayAverage), desc: "fiftyDayAverage")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.twoHundredDayAverage), desc: "twoHundredDayAverage")
                            }
                            HStack(alignment: .center) {
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.trailingAnnualDividendRate), desc: "trailingAnnualDividendRate")
                                NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.trailingAnnualDividendYield), desc: "trailingAnnualDividendYield")
                            }
                            Group {
                                HStack(alignment: .center) {
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.volume24Hr), desc: "volume24Hr")
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.volumeAllCurrencies), desc: "volumeAllCurrencies")
                                }
                                HStack(alignment: .center) {
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.circulatingSupply), desc: "circulatingSupply")
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.navPrice), desc: "navPrice")
                                }
                                HStack(alignment: .center) {
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.currency), desc: "currency")
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.fromCurrency), desc: "fromCurrency")
                                }
                                HStack(alignment: .center) {
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.toCurrency), desc: "toCurrency")
                                    NumberDescView(number: getStringValue(self.identifierSummary?.summaryDetail?.tradable), desc: "tradable")
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: {
            self.fetchChart()
            SwiftYFinance.summaryDataBy(identifier: self.selection?.symbol ?? "") {
                data, error in
                if error != nil {
                    return
                }
                self.identifierSummary = data!
            }
        })
    }

    func fetchChart() {
        var date = Date(timeIntervalSinceNow: -22 * 24 * 60 * 60)
        if self.interval == .oneminute {
            date = Date(timeIntervalSinceNow: -22 * 60)
        } else if self.interval == .fiveminutes {
            date = Date(timeIntervalSinceNow: -22 * 5 * 60)
        } else if self.interval == .thirtyminutes {
            date = Date(timeIntervalSinceNow: -22 * 30 * 60)
        } else if self.interval == .onehour {
            date = Date(timeIntervalSinceNow: -22 * 60 * 60)
        } else if self.interval == .fivedays {
            date = Date(timeIntervalSinceNow: -22 * 5 * 24 * 60 * 60)
        } else if self.interval == .onemonths {
            date = Date(timeIntervalSinceNow: -22 * 30 * 24 * 60 * 60)
        }
        SwiftYFinance.chartDataBy(identifier: self.selection?.symbol ?? "", start: date, interval: self.interval) {
            data, error in
            if error != nil {
                print(error)
                return
            }
            self.chartPoints = (data!.map {
                if $0.close == nil {
                    return 0
                }
                return Double($0.close!)
            }).suffix(20).filter() { $0 != 0 }
        }
    }

    func getStringValue(_ value: Any?) -> String {
        if value == nil {
            return "-"
        } else {
            if let x = value as? Int {
                return String(x)
            } else if let x = value as? Float {
                return String(x)
            } else if let x = value as? String {
                return x
            }
            return "-"
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
