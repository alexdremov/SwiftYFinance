//
//  SheetView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI
import SwiftYFinance

struct SheetView: View {
    var selection: SelectedSymbolWrapper?
    @State var identifierSummary:IdentifierSummary?
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Spacer()
                VStack(spacing: 0){
                    Image(systemName: "line.horizontal.3")
                    Text("pull down to close") .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
            }.padding(.bottom, 5)
            ScrollView(.vertical) {
                VStack{
                    Group{
                        HStack{
                            Text(selection?.symbol ?? "No Symbol")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }.padding(.bottom)
                        HStack{
                            Text("IdentifierSummary\n.recommendationTrend").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  String(self.identifierSummary?.recommendationTrend?.buy ?? 0), desc: "buy")
                            NumberDescView(number:  String(self.identifierSummary?.recommendationTrend?.hold ?? 0), desc: "hold")
                            NumberDescView(number:  String(self.identifierSummary?.recommendationTrend?.sell ?? 0), desc: "sell")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  String(self.identifierSummary?.recommendationTrend?.strongBuy ?? 0), desc: "strongBuy")
                            NumberDescView(number:  String(self.identifierSummary?.recommendationTrend?.strongSell ?? 0), desc: "strongSell")
                        }
                        HStack{
                            Text("IdentifierSummary\n.profile").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.profile?.country ?? "-", desc: "country")
                            NumberDescView(number:  self.identifierSummary?.profile?.city ?? "-", desc: "city")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.profile?.industry ?? "-", desc: "industry")
                            NumberDescView(number:  self.identifierSummary?.profile?.address1 ?? "-", desc: "address1")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.profile?.zip ?? "-", desc: "zip")
                            NumberDescView(number:  String(self.identifierSummary?.profile?.fullTimeEmployees ?? 0), desc: "fullTimeEmployees")
                        }
                        
                        NumberDescView(number:  self.identifierSummary?.profile?.website ?? "-", desc: "website")
                        
                        NumberDescView(number:  self.identifierSummary?.profile?.phone ?? "-", desc: "phone")
                    }
                    Group{
                        NumberDescView(number:  self.identifierSummary?.profile?.sector ?? "-", desc: "sector")
                        
                        VStack(alignment: .leading){
                            Text("Summary:")
                            Text(self.identifierSummary?.profile?.longBusinessSummary ?? "")
                        }.padding()
                        HStack{
                            Text("IdentifierSummary\n.quoteType").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.quoteType?.exchange ?? "", desc: "exchange")
                            NumberDescView(number:  self.identifierSummary?.quoteType?.market ?? "", desc: "market")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.quoteType?.shortName ?? "", desc: "shortName")
                            NumberDescView(number:  self.identifierSummary?.quoteType?.quoteType ?? "", desc: "quoteType")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.quoteType?.exchangeTimezoneShortName ?? "", desc: "exchangeTimezoneShortName")
                            NumberDescView(number:  self.identifierSummary?.quoteType?.exchangeTimezoneName ?? "", desc: "exchangeTimezoneName")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  self.identifierSummary?.quoteType?.symbol ?? "", desc: "symbol")
                            NumberDescView(number:  self.identifierSummary?.quoteType?.longName ?? "", desc: "longName")
                        }
                        HStack{
                            Text("IdentifierSummary\n.price").font(.title)
                                .fontWeight(.semibold)
                                .padding([.top, .leading, .trailing])
                            Spacer()
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  String(self.identifierSummary?.price?.preMarketTime ?? 0), desc: "preMarketTime")
                            NumberDescView(number:  self.identifierSummary?.price?.exchangeName ?? "", desc: "exchangeName")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number:  String(self.identifierSummary?.price?.preMarketChangePercent ?? 0), desc: "preMarketChangePercent")
                            NumberDescView(number:  self.identifierSummary?.price?.currencySymbol ?? "", desc: "currencySymbol")
                        }
                    }
                    Group{
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.regularMarketSource ?? "", desc: "regularMarketSource")
                            NumberDescView(number:  self.identifierSummary?.price?.toCurrency ?? "", desc: "toCurrency")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: String(self.identifierSummary?.price?.regularMarketChange ?? 0), desc: "regularMarketChange")
                            NumberDescView(number:  String(self.identifierSummary?.price?.exchangeDataDelayedBy ?? 0), desc: "exchangeDataDelayedBy")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: String(self.identifierSummary?.price?.marketCap ?? 0), desc: "marketCap")
                            NumberDescView(number:  String(self.identifierSummary?.price?.regularMarketPrice ?? 0), desc: "regularMarketPrice")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: String(self.identifierSummary?.price?.maxAge ?? 0), desc: "maxAge")
                            NumberDescView(number:  String(self.identifierSummary?.price?.regularMarketChangePercent ?? 0), desc: "regularMarketChangePercent")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.currency ?? "", desc: "currency")
                            NumberDescView(number:  String(self.identifierSummary?.price?.averageDailyVolume10Day ?? 0), desc: "averageDailyVolume10Day")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.marketState ?? "", desc: "marketState")
                            NumberDescView(number:  String(self.identifierSummary?.price?.regularMarketDayHigh ?? 0), desc: "regularMarketDayHigh")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.longName ?? "", desc: "longName")
                            NumberDescView(number:  String(self.identifierSummary?.price?.regularMarketDayLow ?? 0), desc: "regularMarketDayLow")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.quoteType ?? "", desc: "quoteType")
                            NumberDescView(number:  String(self.identifierSummary?.price?.preMarketPrice ?? 0), desc: "preMarketPrice")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.preMarketSource ?? "", desc: "preMarketSource")
                            NumberDescView(number:  String(self.identifierSummary?.price?.preMarketChange ?? 0), desc: "preMarketChange")
                        }
                        HStack(alignment: .center){
                            NumberDescView(number: self.identifierSummary?.price?.quoteSourceName ?? "", desc: "quoteSourceName")
                            NumberDescView(number:  String(self.identifierSummary?.price?.regularMarketTime ?? 0), desc: "regularMarketTime")
                        }
                    }
                
                }
            }
        }.onAppear(perform: {
            SwiftYFinance.getBigSummaryOfEquityBy(identifier: self.selection?.symbol ?? ""){
                data, error in
                if error != nil{
                    return
                }
                self.identifierSummary = data!
            }
        })
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
