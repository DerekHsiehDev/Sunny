//
//  SlidingMenuView.swift
//  Sliding Menu
//
//  Created by Derek Hsieh on 1/4/21.
//

import SwiftUI

struct MenuButton: Identifiable {
    var id = UUID()
    var text: String
    var sfsymbol: String
    var action:() -> Void
}

let buttons = [
    MenuButton(text: "Saved", sfsymbol: "bookmark", action: {print("potato")}),
    MenuButton(text: "", sfsymbol: "pencil.circle", action: {print("you pressed the save button")})
    
]

struct SlidingMenuView: View {
    @AppStorage("lightMode") var lightMode = true
    @AppStorage("imperialMode") var imperialMode = true
    @State var imperialModel = true
    
    var body: some View {
        
        HStack {
            VStack {
                Spacer().frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                
                //                ForEach(buttons, id: \.id) { thisButton in
                //                    Button(action: {thisButton.action()}) {
                //                        HStack {
                //
                //                            Text(thisButton.text)
                //                                .padding()
                //                                .foregroundColor(.black)
                //
                //                            Image(systemName: thisButton.sfsymbol)
                //                        }
                //                    }
                //                }
                Text("Settings")
                    .padding()
                    .padding(.leading, 20)
                    .font(.largeTitle)
                    .foregroundColor(lightMode ? .black : .white)
                
                
                HStack {
                    VStack {
                        
                        Text(lightMode ? "light mode" : "dark mode")
                            .padding()
                            .padding(.leading, 40)
                            .foregroundColor(lightMode ? .black : .white)
                        
                        Text(imperialMode ? "imperial" : "metric")
                            .padding()
                            .padding(.leading, 40)
                            .foregroundColor(lightMode ? .black : .white)
                        
         
                    }
                    
                    VStack {
                        
                        Button(action: {
                            lightMode.toggle()
                            
                        }) {
                            Circle()
                                .strokeBorder(lightMode ? Color.black : Color.white,lineWidth: 3)
                                .frame(width: 30, height: 30)
                                .background(Circle().foregroundColor(lightMode ? .white : .black))
                                .padding()
                            
                        }
                        
                        Button(action: {
                            imperialMode.toggle()
                            
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(lightMode ? Color.black : Color.white,lineWidth: 3)
                                .frame(width: 30, height: 30)
                                .background(Circle().foregroundColor(imperialMode ? .white : .black))
                                .padding()
                            
                        }
                    }
                }
                
                
                
                Spacer()
            }.edgesIgnoringSafeArea(.all)
            Spacer()
        }
    }
}
