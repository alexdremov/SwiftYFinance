//
//  GraphingTools.swift
//  BeautyChart
//
//  Created by Александр Дремов on 15.08.2020.
//

import Foundation
import SwiftUI

class GraphingTools{
    class func horizontalLines(_ geo:GeometryProxy, linesCount:Int=6, style:LineViewStyleAdaptive = LineViewStyleAdaptive())->some View{
        let stepper = Float(geo.size.height) / Float(linesCount)
        return ForEach(0..<(linesCount+1)){ index in
            Group{
                Path{path in
                    path.move(to: CGPoint(x: 0, y: CGFloat(stepper) * CGFloat(index)))
                    path.addLine(to: CGPoint(x: CGFloat(geo.size.width), y: CGFloat(stepper) * CGFloat(index)))
                }
                .stroke(Color.gray, style: StrokeStyle( lineWidth: 1, dash: [1]))
                .opacity(0.2)
            }
        }
    }
    
    class func horizontalTicks(_ points:CGPointsSet, _ geo:GeometryProxy, linesCount:Int=6, style:LineViewStyleAdaptive = LineViewStyleAdaptive())->some View{
        let rangesCached = points.ranges
        let limitsCached = points.limits
        let stepper = Float(rangesCached.1) / Float(linesCount)
        let stepperGl = Float(geo.size.height) / Float(linesCount)
        
        var captions: [(Int, String)] = []
        for i in 0...linesCount{
            var format = Float(
                Float(limitsCached.1.0) + stepper * (Float(linesCount) - Float(i))
            )
            if abs(format) < 0.001{
                format = 0.0
            }
            captions.append((i, String(
                (format * 100).rounded() / 100
            )))
        }
        return ForEach(captions, id: \.0){ index in
            Group{
                Text(index.1)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.trailing)
                    .offset(x: CGFloat(index.1.count) * -2)
                    .position(x: -13, y: CGFloat(stepperGl) * CGFloat(index.0)-8)
            }
        }
    }
    
    class func pointsDrawing(_ points:CGPointsSet, _ geo:GeometryProxy, style:LineViewStyleAdaptive = LineViewStyleAdaptive())-> some View{
        ForEach(0..<points.count, id: \.self){ number in
            
            Circle()
                .stroke(style.pointColor, lineWidth: 4)
                .overlay(
                    Circle().fill(Color.white).frame(width:6)
            )
                .frame(width: 8)
                .position(
                    points.affineTransformed(
                        i: number,
                        width: Float(geo.size.width),
                        height: Float(geo.size.height)
                ))
            
        }
    }
}
