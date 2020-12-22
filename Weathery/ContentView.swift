//
//  ContentView.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/20/20.
//

import SwiftUI

struct Cities: Hashable {
    
    var city: String
    var country: String
    
    init(city: String, country: String) {
        self.city = city
        self.country = country
    }
}

var cities = [
    Cities(city: "Corona", country: "California")

]





struct ContentView: View {
    @State var addButtonTapped = false
    @State var searchText = ""
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                if addButtonTapped {
                    
                    CitiesCard()
                }
                
        
                VStack {
                    
                    
                    VStack {
                        Text("heavy rain")
                            .background(
                                RoundedRectangle(cornerRadius: 17)
                                    .fill(Color.blue)
                                    x
                            )
                        
                            
                    }
                    
                    
                    
                    
                
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                            addButtonTapped.toggle()
                            
                        }) {
                            Circle()
                                .fill(addButtonTapped ? .black : Color.white)
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal)
                                .shadow(color: Color(addButtonTapped ? .black : #colorLiteral(red: 0.7450370193, green: 0.7255315781, blue: 0.7254028916, alpha: 1)), radius: 4, x: 0, y: 0)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color( addButtonTapped ? .white : #colorLiteral(red: 0.7450370193, green: 0.7255315781, blue: 0.7254028916, alpha: 1)) )
                                        .font(.system(size: 35, weight: .bold, design: .rounded))
                                        
                                        .rotationEffect(.degrees(addButtonTapped ? 0 : 135))
                                )
                                .animation(.easeInOut)
                        }
                        
                    }
            
            
                }
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CitiesCard: View {
    @State var searchText = ""
    @ObservedObject var fetcher = CityFetcher()

    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    TextField("search city here", text: $searchText)
                    
                    
                    
                }
                .padding()
                
                .background(Color(#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)))
                .cornerRadius(17)
                .frame(width: UIScreen.main.bounds.width - 60, height: 100)
                
                ZStack {
                    ScrollView {
                        ForEach(cities, id: \.self) { city in
                            HStack {
                                Text("\(city.city), ")
                                    .foregroundColor(searchText.isEmpty ? .white : .black)
                                    .fontWeight(.bold)
                                    
                                    .padding(.leading, 40)
                                Text("\(city.country)")
                                    .foregroundColor(searchText.isEmpty ? .white : .black)
                                Spacer()
                                
                                Text("\(59)°")
                                    .foregroundColor(searchText.isEmpty ? .white : .black)
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .padding(.trailing, 40)
                            }
                            .padding(.bottom, 70)
                            
                            Spacer()
                            
                            
                            
                            
                        }.padding(.top, 30)
                    }
                
                    if searchText.count >= 3 {
                        ScrollView {
                            ForEach(fetcher.cities.filter({"\($0)".contains(searchText)}), id: \.self) { city in


                                HStack {
                                    Text("\(city.city ?? ""), \(city.country ?? "")")
                                        .foregroundColor(.white)
                                    Spacer()
                                        
                                        
                                    .padding()
                                }
                                .background(Color.black)
                                .padding(.horizontal, 40)
                                .onTapGesture {
                                    searchText = ""
                                    
                                    cities.append(Cities(city: city.city!, country: city.country!))
                                    
                                }
                                Divider()
                                    .background(Color(.systemGray4))
                                    .padding(.leading, 40)
                                    

                            }
                        }

                    }
                }
                
                
                
                Spacer()
            }.padding(.top, 50)
        }.background(
            RoundedRectangle(cornerRadius: 25)
                .transition(AnyTransition.slide.combined(with: .opacity).animation(.easeInOut(duration: 2.0)))
                .padding(.top, 50)
                .padding(.horizontal, 10)
        )
    }
}

struct CitiesViewPreview: PreviewProvider {
    static var previews: some View {
        CitiesCard()
    }
}
