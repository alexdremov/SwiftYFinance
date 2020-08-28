//
//  PressLineView.swift
//  BeautyChart
//
//  Created by Александр Дремов on 15.08.2020.
//

import SwiftUI

struct PressLineView: View {
    var pressPosition:Binding<CGPoint>
    var indicatorPoint:Binding<CGPoint>
    var text:Binding<String>
    
    var style:LineViewStyleAdaptive
    
    var body: some View {
        ZStack{
            IndicatorPoint(style:style).position(indicatorPoint.wrappedValue)
            Group{
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(self.style.movingRectColor, lineWidth: 2)
                        .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                        .opacity(0.5)
                        .frame(width: 60, height: proxy.size.height)
                        .position(x: self.pressPosition.wrappedValue.x, y: proxy.size.height / 2)
                }
            }
            
            Text(text.wrappedValue)
                .fontWeight(.semibold)
                .position(x: pressPosition.wrappedValue.x, y: 20)
        }.drawingGroup()
        
    }
}
