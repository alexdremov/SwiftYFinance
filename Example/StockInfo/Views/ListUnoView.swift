//
//  ListUnoView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI
import SwiftYFinance

struct ListUnoView: View {
    var result: YFQuoteSearchResult?

    var body: some View {
        VStack(alignment: .leading) {
            Text(result?.symbol ?? "Not symbol")
                .font(.title)
                .fontWeight(.semibold)
            Text("\(result?.longname ?? "-") | \(result?.shortname ?? "-")")
        }.padding(.all)
    }
}

struct ListUnoView_Previews: PreviewProvider {
    static var previews: some View {
        ListUnoView()
    }
}
