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
        Cities(city: "Corona", country: "United States")
        
    ]

    
    





struct ContentView: View {
    @State var addButtonTapped = false
    
    @State var searchText = ""
    @State var selectedCity = cities.first!
    @ObservedObject var fetcher = CityFetcher()
    @State var keyboardInUse = false
//    @State var temps = [String: Int]()

   @ObservedObject public var viewModel = WeatherViewModel()


    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
       
                
                VStack {
                    
                    Button(action: {addButtonTapped.toggle()
                        
                        print(selectedCity.city)
                        
                        viewModel.fetchWeather(city: selectedCity.city)
                    }) {
                        
                        HStack {
                            Spacer()
                            Text(addButtonTapped ? "add" : "\(selectedCity.city),")
                                .fontWeight(addButtonTapped ? .light : .bold)
                                .foregroundColor(.black)
                            Text(addButtonTapped ? "city" : "\(selectedCity.country)")
                                .fontWeight(addButtonTapped ? .bold : .light)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding()
                        
                    }
                    
                    if addButtonTapped {
                        
                        VStack {
                            VStack {
                                
                                HStack {
                                    TextField("search city here", text: $searchText)
                                    
                                    
                                    
                                }
                                .onTapGesture {
                                    keyboardInUse = true
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
                                                
//                                                Text("\(0)°")
//                                                    .foregroundColor(searchText.isEmpty ? .white : .black)
//                                                    .fontWeight(.bold)
//                                                    .font(.title3)
//                                                    .padding(.trailing, 40)
                                            }
//                                            .onAppear {
//                                                viewModel.fetchOneCityWeather(city: city.city.lowercased())
//                                            }
                            
                                            .onTapGesture {
                                                selectedCity = city
                                            
                                                self.viewModel.fetchWeather(city: (city.city as NSString).replacingOccurrences(of: " ", with: "+"))
                                                
                                                addButtonTapped = false
                                                
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
                                                    keyboardInUse = false
                                                    self.hideKeyboard()
                                                    
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
                            }
                            //            .padding(.top, 50)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 15, height: keyboardInUse ? 450 : 600)
                        .transition(AnyTransition.opacity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                
                                //                .padding(.top, 50)
                                .padding(.horizontal, 10)
                        )
                    } else {
                        
                        
                        VStack {
                            
                            
                            
                            //                                VStack(alignment: .leading) {
                            //
                            //                                    Image(systemName: "cloud.heavyrain.fill")
                            //
                            //                                        .font(.system(size: 75))
                            //
                            //                                        .foregroundColor(.white)
                            //
                            //
                            //                                        .padding(.horizontal)
                            //                                        .padding(.top, 30)
                            //
                            //
                            
                            //
                            //                                }
                            //
                            
                            
                            HStack(alignment: .center) {
                                Image(systemName: "cloud.heavyrain.fill")
                                    
                                    .font(.system(size: 75))
                                    
                                    .foregroundColor(.white)
                                    
                                    
                                    .padding(.horizontal)
                                    .padding(.top, 30)
                                
                                Spacer()
                                
                                Text("\((viewModel.currentTemp) ?? 0)°")
                                    .foregroundColor(.white)
                                    .font(.system(size: 75, weight: .bold, design: .default))
                                    .padding(.horizontal)
                                    .padding(.top, 30)
                            }
                            
                            
                            
                            HStack(alignment: .center) {
                                Text("heavy rain")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                                    
                                    .padding(.horizontal)
                                    .padding(.bottom, 15)
                                
                                Spacer()
                          
                                    
                                Text("feels like: \((viewModel.currentTemp) ?? 0)°")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .bold, design: .default))
                                        .padding(.horizontal)
                                        .padding(.bottom, 15)
                                
                                
                            }
                            .padding()
                            
                            
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 45, height: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4078431373, green: 0.7411764706, blue: 0.9803921569, alpha: 1)), Color(#colorLiteral(red: 0.2745098039, green: 0.5098039216, blue: 0.9921568627, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
                            
                        ).padding(.bottom, 15)
                        
                        HStack {
                            
                            VStack() {
                                Text("humidity")
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
//
//                                Spacer()
                                
                                Text("\(viewModel.currentWeather?.main.humidity ?? 0)")
                                    .font(.system(size: 23, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                                    .padding()
                                
                                
                            }
                            
                            VStack {
                                
                                Text("wind")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
//                                Spacer()
                                
                                HStack(spacing: 5) {
                                    Text("\(Int(viewModel.currentWeather?.wind.speed ?? 0))")
                                        .font(.system(size: 23, weight: .bold, design: .default))
                                        .foregroundColor(Color(.black))
                                        
                                    Text("mph")
                                        .font(.caption2)
                                        .lineLimit(1)
                                      
                                        .foregroundColor(Color(#colorLiteral(red: 0.4431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)))
                                }.padding()
                                
                                    
                                
                            }
                            
                            VStack {
                                Text("high")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
//                                Spacer()
                                
                                Text("\(viewModel.currentTempMax ?? 0)°")
                                    .font(.system(size: 23, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.7215686275, green: 0.3529411765, blue: 1, alpha: 1)))
                                    .padding()
                                
                            }
                            
                            VStack {
                                Text("low")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
//                                Spacer()
                                
                                Text("\(viewModel.currentTempMin ?? 0)°")
                                    .font(.system(size: 23, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9098039216, green: 0.6549019608, blue: 0.1725490196, alpha: 1)))
                                    .padding()
                            }
                            
                        }.frame(width: UIScreen.main.bounds.width - 45, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
                        )
                        
                    }
                    
                   
                        Spacer()
                    
                    
                    
                    
                    

                    HStack {
                        Spacer()

                        Button(action: {

                            addButtonTapped.toggle()

                        }) {
                            Circle()
                                .fill(addButtonTapped ? .black : Color.white)
                                .frame(width: 100, height: 100)
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
            .onAppear(perform: {
                
                viewModel.fetchWeather(city: selectedCity.city)
            })
            
        }
        
    }
    

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct CitiesCard: View {
//
//
//    @Binding var selectedCity: Cities
//  @ObservedObject private var viewModel = WeatherViewModel()
//    @Binding var addButtonTapped: Bool
//
//    var body: some View {
//
//    }
//}





#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
