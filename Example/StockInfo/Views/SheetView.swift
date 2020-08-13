//
//  SheetView.swift
//  StockInfo
//
//  Created by Александр Дремов on 12.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI

struct SheetView: View {
    var selection: SelectedSymbolWrapper?
    var body: some View {
        VStack{
            HStack{
                Text(selection?.symbol ?? "No Symbol")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding([.top, .leading, .trailing])
                Spacer()
            }
            Spacer()
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
