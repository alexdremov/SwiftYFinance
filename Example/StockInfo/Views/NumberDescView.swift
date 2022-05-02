//
//  NumberDescView.swift
//  StockInfo
//
//  Created by Александр Дремов on 13.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

import SwiftUI

struct NumberDescView: View {
    var number: Any?
    var desc: Any?
    var body: some View {
        VStack(alignment: .center) {
            Text("\(number as? String ?? "")" )
                .font(.title)
                .fontWeight(.bold)
            Text("\(desc as? String ?? "")")
                .font(.subheadline)
                .fontWeight(.regular)
        }
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct NumberDescView_Previews: PreviewProvider {
    static var previews: some View {
        NumberDescView()
    }
}
