//
//  LineViewStyle.swift
//  BeautyChart
//
//  Created by Александр Дремов on 15.08.2020.
//

import Foundation
import SwiftUI

public class LineViewStyle{
    public var lightTheme = LineViewStyleAdaptive()
    public var darkTheme = LineViewStyleAdaptive()
    
    
    
    func adaptive(colorScheme:ColorScheme) -> LineViewStyleAdaptive{
        if colorScheme == .dark{
            return darkTheme
        }else{
            return lightTheme
        }
    }
    
    public init(){
        self.darkTheme.globalBackground = Color.black
        self.darkTheme.movingPointColor = Colors.GradientNeonBlue
    }
    
    public init(lightTheme:LineViewStyleAdaptive, darkTheme:LineViewStyleAdaptive){
        self.darkTheme = darkTheme
        self.lightTheme = lightTheme
    }
    
    
    public func mode2()->LineViewStyle{
        let selfCopy = self.copy()
        selfCopy.darkTheme.firstGradientColor = Colors.GradientPurple
        selfCopy.lightTheme.firstGradientColor  = selfCopy.darkTheme.firstGradientColor
        
        selfCopy.darkTheme.secondGradientColor = Colors.BorderBlue
        selfCopy.lightTheme.secondGradientColor = selfCopy.darkTheme.secondGradientColor
        
        selfCopy.lightTheme.pointColor = Colors.DarkPurple
        selfCopy.darkTheme.pointColor = selfCopy.lightTheme.pointColor
        
        selfCopy.lightTheme.movingPointColor = Colors.LightGreenAccent
        selfCopy.darkTheme.movingPointColor = selfCopy.lightTheme.movingPointColor
    
        return selfCopy
    }
    
    public func copy() -> LineViewStyle {
        let copy = LineViewStyle(lightTheme: self.lightTheme, darkTheme: self.darkTheme)
           return copy
       }
}

public struct LineViewStyleAdaptive{
    public var aspectRatio:CGFloat = 1.3
    public var contentMode:ContentMode = .fit
    
    public var bezierStepMode = true
    public var bezierStepSmoothen = 0.06
    public var noInterpolation = false
    
    public var globalBackground:Color = Color.white
    
    public var dropShadow:Bool = true
    public var shadowColor:Color = .gray
    public var shadowRadius:Float = 3
    
    public var displayHLines:Bool = false
    public var displayPoints:Bool = false
    
    public var displayHTicks:Bool = true
    public var ticksLeftPadding:CGFloat = 55
    
    public var firstGradientColor:Color = Colors.OrangeStart
    public var secondGradientColor:Color = Colors.OrangeEnd
    
    public var underLineFill:Bool = true
    
    public var pointColor:Color = Colors.OrangeStart
    
    public var movingPointColor:Color = Colors.DarkPurple
    public var movingRectColor:Color = Colors.GradientPurple
    
    public var movingFrameCloserPointMethod:[Axis] = [.horizontal]
    
    public var showInterpolationValue = false
    public var showedValueRounding:Int = 2
    
    public var magnifyOnLongPress:Bool = false
    
    
    public init(){}
}
