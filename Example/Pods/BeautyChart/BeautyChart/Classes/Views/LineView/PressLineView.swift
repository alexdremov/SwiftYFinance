//
//  PressLineView.swift
//  BeautyChart
//
//  Created by Александр Дремов on 15.08.2020.
//

import SwiftUI

struct PressLineView: View {
    @ObservedObject var position:PressPositionWrapper
    var style:LineViewStyleAdaptive
    
    var rectOutlay = 5
    
    var body: some View {
        ZStack{
            IndicatorPoint(style:style).position(position.pointPosition)
            Group{
                RoundedRectangle(cornerRadius: 14)
                    .stroke(style.movingRectColor, lineWidth: 2)
                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                    .opacity(0.5)
                    .frame(width: 60, height: position.coordinates!.size.height + CGFloat(rectOutlay * 2))
                    .position(x: position.pointPosition.x, y: (position.coordinates!.size.height)/2 - CGFloat(rectOutlay / 2))
            }
            
            Text(position.text)
                .fontWeight(.semibold)
            .position(x: position.pointPosition.x, y: position.coordinates!.size.height*0.2)
        }.drawingGroup()
        
    }
}
