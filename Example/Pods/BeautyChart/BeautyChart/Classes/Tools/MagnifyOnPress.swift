//
//  MagnifyOnPress.swift
//  BeautyChart
//
//  Created by Александр Дремов on 25.08.2020.
//

import Foundation
import SwiftUI


struct MagnifyOnPress:ViewModifier{
    
    @State private var isDetectingLongPress = false
    
    func body(content: Content) -> some View {
        content
            .animation(nil)
            .scaleEffect(isDetectingLongPress ? 1.01: 1)
            .animation(.easeOut(duration: 1))
            .onLongPressGesture(minimumDuration: 5.0, pressing: { (isPressing) in
                self.isDetectingLongPress = isPressing
            }, perform: {
                
            })
    }
    
}
