//
//  ChartSmoothView.swift
//  BeautyChart
//
//  Created by Александр Дремов on 15.08.2020.
//

import Foundation
import SwiftUI


public struct ChartSmoothView: View{
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var lookUpTable:LookUpTable = LookUpTable(path: Path())
    
    @State private var percentage: CGFloat = .zero
    @State var mainPath:Path?
    
    @State var pressVisible:Bool = false
    
    @State var pressText:String = ""
    @State var indicatorPosition:CGPoint = CGPoint(x:0, y:0)
    @State var pressPosition:CGPoint = CGPoint(x:0, y:0)
    
    var title:String = ""
    var caption:String = ""
    
    var style:LineViewStyle = LineViewStyle()
    
    var styleAdaptive:LineViewStyleAdaptive{
        self.style.adaptive(colorScheme: self.colorScheme)
    }
    
    public init(points:[CGPoint], title:String = "", caption:String = "", style:LineViewStyle = LineViewStyle()){
        self.points = CGPointsSet(points: points)
        self.title = title
        self.caption = caption
        self.style = style
    }
    
    var points:CGPointsSet = CGPointsSet()
    
    func pathDrawing(_ geo:GeometryProxy, forFill:Bool=false) -> Path{
        var path = Path()
        
        if (self.points.count == 0)
        {
            return path
        }
        
        let firstTransformed = self.points.affineTransformed(i:0, width: Float(geo.size.width), height: Float(geo.size.height))
        let firstOutlier = CGPoint(x:firstTransformed.x - 5,y: firstTransformed.y)
        
        let lastTransformed = self.points.affineTransformed(i:self.points.count - 1, width: Float(geo.size.width), height: Float(geo.size.height))
        let lastOutlier = CGPoint(x:lastTransformed.x + 5,y: lastTransformed.y)
        
        let drawPoints = [firstOutlier] + self.points.affineTransformed(width: Float(geo.size.width), height: Float(geo.size.height)) + [lastOutlier]
        
        var controlPoints:[BezierSegmentControlPoints] = []
        if !self.styleAdaptive.noInterpolation{
            if !self.styleAdaptive.bezierStepMode{
                let config = BezierConfiguration()
                controlPoints = config.configureControlPoints(data:drawPoints)
            }else{
                for i in 0..<(drawPoints.count-1){
                    let fPoint = CGPoint(x: drawPoints[i].x+CGFloat(self.styleAdaptive.bezierStepSmoothen) * geo.size.width,y: drawPoints[i].y)
                    let sPoint = CGPoint(x: drawPoints[i+1].x-CGFloat(self.styleAdaptive.bezierStepSmoothen) * geo.size.width,y: drawPoints[i+1].y)
                    let tmpContrPoint = BezierSegmentControlPoints(firstControlPoint: fPoint, secondControlPoint: sPoint)
                    controlPoints.append(tmpContrPoint)
                }
            }
        }
        path.move(to:  self.points.affineTransformed(i: 0, width: Float(geo.size.width), height: Float(geo.size.height)))
        for point in 1..<self.points.count{
            let graphPoint = self.points.affineTransformed(i: point, width: Float(geo.size.width), height: Float(geo.size.height))
            if !self.styleAdaptive.noInterpolation{
                path.addCurve(
                    to: graphPoint,
                    control1: controlPoints[point].firstControlPoint,
                    control2: controlPoints[point].secondControlPoint)
            }else{
                path.addLine(to: graphPoint)
            }
        }
        
        
        if forFill{
            path.addLine(to: CGPoint(x:lastTransformed.x, y:CGFloat(geo.size.height)))
            path.addLine(to: CGPoint(x:0, y:CGFloat(geo.size.height)))
        }else{
            DispatchQueue.main.async {
                self.lookUpTable = LookUpTable(path: path)
                self.mainPath = path
            }
        }
        return path
    }
    
    
    public var body: some View{
        GeometryReader{
            geoGlob in
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    if (self.title != ""){
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding([.top, .leading])
                    }
                    if (self.caption != ""){
                        Text(self.caption)
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(Color.gray)
                            .padding([.leading])
                    }
                }
                ZStack{
                    if (self.points.count > 1)
                    {
                        GeometryReader {
                            geo in
                            Group{
                                ZStack {
                                    Group {
                                        if self.styleAdaptive.displayHLines {
                                            GraphingTools.horizontalLines(geo, style:self.styleAdaptive)
                                        }
                                        
                                        self.pathDrawing(geo).trim(from: 0, to: self.percentage) // << breaks path by parts, animatable
                                            .stroke(LinearGradient(gradient: Gradient(colors: [self.styleAdaptive.firstGradientColor, self.styleAdaptive.secondGradientColor]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                            .animation(.easeOut(duration: 1.0)) // << animate
                                            .onAppear {
                                                self.percentage = 1.0
                                        }
                                        if self.styleAdaptive.underLineFill {
                                            self.pathDrawing(geo, forFill: true)
                                                .fill(LinearGradient(gradient: Gradient(colors: [self.styleAdaptive.firstGradientColor, self.styleAdaptive.secondGradientColor]), startPoint: .leading, endPoint: .trailing))
                                                .opacity(0.15)
                                                .animation(nil)
                                                .blur(radius: 4, opaque: false)
                                                .opacity(self.percentage == 1.0 ? 1 : 0)
                                                .animation(.easeOut(duration: 1.5)) // << animate
                                        }
                                        if self.styleAdaptive.displayPoints {
                                            GraphingTools.pointsDrawing(self.points, geo, style:self.styleAdaptive)
                                                .animation(nil)
                                                .opacity(self.percentage == 1.0 ? 1 : 0)
                                                .animation(.easeOut(duration: 1.0))
                                        }
                                        if self.styleAdaptive.displayHTicks {
                                            GraphingTools.horizontalTicks(self.points, geo, style:self.styleAdaptive)
                                        }
                                        
                                    }
                                    if (self.pressVisible) {
                                        PressLineView(pressPosition: self.$pressPosition, indicatorPoint: self.$indicatorPosition, text: self.$pressText, style: self.styleAdaptive)
                                    }
                                }
                                
                            }
                            .contentShape(Rectangle())
                            .gesture(DragGesture()
                            .onChanged({ value in
                                self.indicatorPosition = self.lookUpTable.getClosestPoint(fromPoint: value.location, axes: [.horizontal])
                                
                                self.pressPosition = value.location
                                
                                if value.location.x <= geo.size.width && value.location.x >= 0{
                                    
                                    let revPoint =  self.points.reverseAffine(self.indicatorPosition, width: Float(geo.size.width), height: Float(geo.size.height), vMirrored: true)
                                    
                                    
                                    var closest =  self.points.closestPoint(revPoint, axes: self.styleAdaptive.movingFrameCloserPointMethod)
                                    if self.styleAdaptive.showInterpolationValue{
                                        closest = revPoint
                                    }
                                    
                                    let expPoints = Double(pow(Double(10), Double(self.styleAdaptive.showedValueRounding)))
                                    closest.y = CGFloat((Double(closest.y) * expPoints).rounded() / expPoints)
                                    
                                    if self.pressText !=  String(Float(closest.y)){
                                        HapticFeedback.playSelection()
                                    }
                                    self.pressText =  String(Float(closest.y))
                                    self.pressVisible = true
                                } else {
                                    self.pressVisible = false
                                }
                            }).onEnded({ value in
                                self.pressVisible = false
                            })
                            )
                        }
                        .padding([.bottom, .trailing], 30)
                        .if(self.styleAdaptive.displayHTicks){
                            $0.padding(.leading, self.styleAdaptive.ticksLeftPadding)
                        }.if(!self.styleAdaptive.displayHTicks){
                            $0.padding(.leading, 30)
                        }.padding(.top, 30)
                        
                    }else{
                        Text("No data").font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(Color.gray)
                            .position(x: geoGlob.size.width/2, y: geoGlob.size.height/2)
                    }
                }.drawingGroup()
            }
        }
        .aspectRatio(self.styleAdaptive.aspectRatio, contentMode: self.styleAdaptive.contentMode)
        .background(self.styleAdaptive.globalBackground)
        .cornerRadius(10).if(self.styleAdaptive.dropShadow){
            $0.shadow(color: self.styleAdaptive.shadowColor, radius: CGFloat(self.styleAdaptive.shadowRadius), x: 0, y: 0)
        }.if(self.styleAdaptive.magnifyOnLongPress){
            $0.modifier(MagnifyOnPress())
        }
        
    }
} 

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartSmoothView(points: [
            CGPoint(x: 0, y: 17),
            CGPoint(x: 1, y: 23),
            CGPoint(x: 2, y: 60),
            CGPoint(x: 3, y: 32),
            CGPoint(x: 4, y: 12),
            CGPoint(x: 5, y: 37),
            CGPoint(x: 6, y: 7),
            CGPoint(x: 7, y: 23),
            CGPoint(x: 8, y: 60),
        ]).padding()
    }
}
