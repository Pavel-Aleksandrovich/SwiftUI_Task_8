//
//  ContentView.swift
//  SwiftUI_Task_8
//
//  Created by pavel mishanin on 22/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value: Double = 0
    @State private var hScale: Double = 1
    @State private var vScale: Double = 1
    @State private var vOffset: CGFloat = 0
    @State private var startValue: CGFloat = 0
    @State private var anchor: UnitPoint = .center
    @State private var isTouching = false
    
    var body: some View {
        
        ZStack {
            
            Color.gray.ignoresSafeArea()
            
            
            slider
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
                .frame(width: Constants.shapeSize.width, height: Constants.shapeSize.height)
                .scaleEffect(x: hScale, y: vScale, anchor: anchor)
                .offset(x: 0, y: vOffset)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        if !isTouching {
                            startValue = value
                        }
                        
                        isTouching = true
                        
                        
                        var value = startValue - (drag.translation.height/Constants.shapeSize.height)
                        self.value = min(max(value,0.0), 1.0)
                        
                        
                        // top
                        
                        if value > 1 {
                            value = sqrt(sqrt(sqrt(value)))
                            anchor = .bottom
                            vOffset = Constants.shapeSize.height * (1 - value)/2
                            
                            
                            // bottom
                            
                        } else if value < 0 {
                            value = sqrt(sqrt(sqrt(1 - value)))
                            anchor = .top
                            vOffset = -Constants.shapeSize.height * ( 1 - value)/2
                            
                            
                        } else {
                            value = 1.0
                            anchor = .center
                            
                        }
                        
                        vScale = value
                        hScale = 2 - value
                        
                        
                    }
                         
                         // end of interaction
                         
                    .onEnded {_ in
                        isTouching = false
                        vScale = 1
                        hScale = 1
                        anchor = .center
                        vOffset = 0
                    })
            
                .animation(isTouching ? .none : .spring, value: vScale)
        }
    }
    
    
    var slider: some View {
        Rectangle()
            .foregroundStyle(.ultraThinMaterial)
            .overlay {
                VStack {
                    
                    Spacer()
                        .frame(minHeight: 0)
                    
                    Rectangle()
                        .frame(width: Constants.shapeSize.width, height: value * Constants.shapeSize.height)
                        .foregroundColor(.white)
                }
            }
    }
}

private enum Constants {
    static let shapeSize = CGSize(width: 80, height: 240)
    static let cornerRadius: CGFloat = 25
}
