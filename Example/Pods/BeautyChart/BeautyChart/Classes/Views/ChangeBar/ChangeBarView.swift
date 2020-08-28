//
//  ChangeBarView.swift
//  BeautyChart
//
//  Created by Александр Дремов on 17.08.2020.
//

import SwiftUI

public struct ChangeBarView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var animate = false
    
    var changePercent:Float
    
    var percentProxy:Float{
        self.styleAdaptive.modifier(changePercent)
    }
    var title:String = ""
    var caption:String = ""
    
    var style:ChangeBarStyle
    
    public init(changePercent:Float, style:ChangeBarStyle = ChangeBarStyle(), title:String="", caption:String="") {
        self.style = style
        self.changePercent = changePercent
        self.title = title
        self.caption = caption
    }
    
    var styleAdaptive:ChangeBarStyleAdaptive{
        self.style.adaptive(colorScheme: self.colorScheme)
    }
    
    public var body: some View {
        var objHeight:CGFloat = 80;
        
        if self.title != "" {
            objHeight += 25
        }
        
        if self.caption != "" {
            objHeight += 20
        }
        
        if self.caption != "" && self.title == "" {
            objHeight = 90
        }
        
        var fillGrad = LinearGradient(gradient: Gradient(colors: [self.styleAdaptive.posFirstGradientColor, self.styleAdaptive.posSecondGradientColor]), startPoint: .leading, endPoint: .trailing)
        
        if self.changePercent < 0 {
            fillGrad = LinearGradient(gradient: Gradient(colors: [self.styleAdaptive.negFirstGradientColor, self.styleAdaptive.negSecondGradientColor]), startPoint: .leading, endPoint: .trailing)
        }
        
        let expPoints = Float(pow(Double(10), Double(self.styleAdaptive.showedValueRounding)))
        let roundedPercent = Float(self.changePercent * expPoints * 100).rounded() / expPoints
        
        return GeometryReader{
            geo in
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 0) {
                    if self.title != "" {
                        Text(self.title)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    if self.caption != "" {
                        Text(self.caption)
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(Color.gray).padding(0)
                    }
                    HStack{
                        if self.percentProxy > 0 {
                            Image(systemName: "arrow.up").foregroundColor(Color.green)
                        }else{
                            Image(systemName: "arrow.down").foregroundColor(Color.red)
                        }
                        Text(String(roundedPercent) + "%")
                            .font(.callout)
                            .fontWeight(.regular)
                            .if(self.percentProxy > 0) {
                                $0.foregroundColor(Color.green)
                        }
                        .if(self.percentProxy < 0) {
                            $0.foregroundColor(Color.red)
                        }
                    }
                }.padding([.top, .leading])
                
                Rectangle()
                    .fill(fillGrad)
                    .frame(width: !self.animate ? 0 : (geo.size.width - CGFloat(self.styleAdaptive.sideMargin * 2)) * CGFloat(self.percentProxy / 2), height:20)
                    .position(x: !self.animate ? geo.size.width / 2 :((geo.size.width - CGFloat(self.styleAdaptive.sideMargin * 2)) * ( 0.5 +  CGFloat(self.percentProxy) * 0.25)), y: 0)
                    .animation(.easeOut(duration: 1.5))
                    .opacity(0.7)
                
            }
        }.frame(height: objHeight).aspectRatio(contentMode: self.styleAdaptive.contentMode)
            .background(self.styleAdaptive.globalBackground)
            .cornerRadius(10).shadow(color: self.styleAdaptive.shadowColor, radius: CGFloat(self.styleAdaptive.shadowRadius), x: 0, y: 0)
            .if(self.styleAdaptive.magnifyOnLongPress){
                $0.modifier(MagnifyOnPress())
            }
            .onAppear(){
                self.animate = true
        }
    }
}

public struct ChangeBarView_Previews: PreviewProvider {
    public static var previews: some View {
        ChangeBarView(changePercent: -0.9)
            .padding()
    }
}
