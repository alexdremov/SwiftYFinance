//
//  ContentView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI
import SwiftYFinance

struct ContentView: View {
    @State var searchString: String = "AAPL"
    @State var foundContainer: [YFQuoteSearchResult] = []

    @State var sheetVisible = false
    @ObservedObject var selection = SelectedSymbolWrapper()
    var body: some View {
        VStack {
            HStack {
                Text("Stock Info")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                Spacer()
            }.padding([.top, .leading, .trailing])
            TextField("Search", text: $searchString, onCommit: self.searchObjects)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(5).padding(.horizontal)

            Group {
                List {
                    ForEach(self.foundContainer, id: \.symbol) {result in
                        Button(action: {
                            self.selection.symbol = result.symbol
                            self.sheetVisible = true
                        }) {
                            ListUnoView(result: result).listRowInsets(EdgeInsets())
                        }
                    }.listRowInsets(EdgeInsets())
                }.padding(0.0)
            }
            Spacer()
        }.sheet(isPresented: self.$sheetVisible, content: {
            SheetView(selection: self.selection)
        }).onAppear(perform: self.searchObjects)
    }

    func searchObjects() {
        SwiftYFinance.fetchSearchDataBy(searchTerm: self.searchString) {data, error in
            if error != nil {
                return
            }
            self.foundContainer = data!
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SelectedSymbolWrapper: ObservableObject {
    @Published var symbol: String?
    init(symbol: String) {
        self.symbol = symbol
    }
    init() {
    }
}
