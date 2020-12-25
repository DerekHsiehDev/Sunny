//
//  HourlyTemperatureCard.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/25/20.
//

import SwiftUI

struct HourlyTemperatureCard: View {
    let circleWidth: CGFloat = UIScreen.main.bounds.width + 100
    let selectorYOffset: CGFloat = 5
    @State var rotateState: Double = 0
    @State var dragTranslation = CGSize.zero
    @State private var dragging = false
    
    var body: some View {
        VStack {
           
            Text("today")
                .font(.system(size: 20, weight: .semibold, design: .default))
            ZStack() {
                Circle()
                    .stroke(style:  StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        dash: [20]
                        
                    ))
                    .frame(width: circleWidth, height: circleWidth)
                 
                    .rotationEffect(Angle(degrees: Double(self.dragTranslation.width/10)), anchor: .center)
                    
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    dragTranslation = value.translation
                                    print(value.translation.width)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    dragging = true
                                })
                                .onEnded({ (value) in
                                        if value.translation.width <= 200 {
                                            dragTranslation = CGSize.zero
                                        }
                                    dragging = false
                                })
                    
                    )
                    .animation(.spring(response: 2, dampingFraction: 0.3, blendDuration: 0.3), value: true)
                    .edgesIgnoringSafeArea(.bottom)
                
                
                if dragTranslation.width <= 200 {
                    Text("today")
                } else {
                    Text("tomorrow")
                }
                
            }
        }.offset(x: 0, y: 200)
    }
}

struct HourlyTemperatureCard_Previews: PreviewProvider {
    static var previews: some View {
        HourlyTemperatureCard()
    }
}
