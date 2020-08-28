//
//  ChangeBarStyle.swift
//  BeautyChart
//
//  Created by Александр Дремов on 17.08.2020.
//

import Foundation
import SwiftUI

public class ChangeBarStyle{
    public var lightTheme = ChangeBarStyleAdaptive()
    public var darkTheme = ChangeBarStyleAdaptive()
    
    
    
    func adaptive(colorScheme:ColorScheme) -> ChangeBarStyleAdaptive{
        if colorScheme == .dark{
            return darkTheme
        }else{
            return lightTheme
        }
    }
    
    public init(){
        
    }
    
    public init(lightTheme:ChangeBarStyleAdaptive, darkTheme:ChangeBarStyleAdaptive){
        self.darkTheme = darkTheme
        self.lightTheme = lightTheme
    }
    
    
    public func mode2()->ChangeBarStyle{
        let selfCopy = self.copy()
        
        
        
        return selfCopy
    }
    
    public func copy() -> ChangeBarStyle {
        let copy = ChangeBarStyle(lightTheme: self.lightTheme, darkTheme: self.darkTheme)
        return copy
    }
}

public struct ChangeBarStyleAdaptive{
    public var contentMode:ContentMode = .fill
    
    public var globalBackground:Color = Color.white
    
    public var dropShadow:Bool = true
    public var shadowColor:Color = .gray
    public var shadowRadius:Float = 3
    
    public var sideMargin:Float = 10
    
    public var showedValueRounding:Int = 2
    
    public var modifier: (Float)->Float {
        return {tanh($0)}
    }
    
    public var posFirstGradientColor:Color = Colors.LightGreenAccent
    public var posSecondGradientColor:Color = Colors.LightGreen
    
    public var negFirstGradientColor:Color = Colors.OrangeEnd
    public var negSecondGradientColor:Color = Colors.OrangeStart
    
    public var magnifyOnLongPress:Bool = false
    
    public init(){}
}
