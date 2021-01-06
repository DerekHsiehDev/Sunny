//
//  ContentView.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/20/20.
//

import SwiftUI
import CoreLocation
import CoreData


struct Cities: Hashable {
    
    var city: String
    var country: String
    var lat: Double
    var lng: Double
    
    
    init(city: String, country: String, lat: Double, lng: Double) {
        self.city = city
        self.country = country
        self.lat = lat
        self.lng = lng
    }
}





var citiesList = [
    Cities(city: "Current Location", country: "", lat: 0.0, lng: 0.0)
]



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: City.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \City.city, ascending: true)
    ]) private var cities: FetchedResults<City>

    private var indexOfCities = 0
    @State private var citiesArray = [String]()
    @State private var menuShown = false
    @State var addButtonTapped = false
    @State var hourlyTemps = [Hourly]()
    @State var searchText = ""
    @State var currentLocation = true
    @State var selectedCity = citiesList.first!
    @ObservedObject var fetcher = CityFetcher()
    @State var keyboardInUse = false
    @State private var draggedOffset = CGSize.zero
    @State private var dismissCard = false
    
    //    @State var temps = [String: Int]()
    
    //circle view
    let circleWidth: CGFloat = 300 //UIScreen.main.bounds.width + 300
    let selectorYOffset: CGFloat = 5
    @State var rotateState: Double = 0
    @State var dragTranslation = CGSize.zero
    @State private var dragging = false
    @State var showNextWeek = false
    
    @ObservedObject public var viewModel = WeatherViewModel()
    @AppStorage("lightMode") var lightMode = true
    @AppStorage("imperialMode") private var imperialMode = true
    @ObservedObject private var locationManager = LocationManager()
    
    fileprivate func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("unresolved err: \(error)")
        }
    }
    
    var body: some View {
        
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        ZStack {
            SlidingMenuView()
                .background( Color(lightMode ? .white : .black)
                                .edgesIgnoringSafeArea(.all)
                                 )
        ZStack {
            
            Color(lightMode ? #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1) : .black)
                .shadow(color: lightMode ? .black : .white, radius: 4)
                .edgesIgnoringSafeArea(.all)
                
            
            
            
            
            VStack(alignment: .center) {
                
                
                VStack {
                    
                    Button(action: {
                        addButtonTapped.toggle()
                        showNextWeek = false
                        
                        keyboardInUse = false
                        //                        viewModel.fetchWeather(city: selectedCity.city)
                    }) {
                        
                        HStack {
                            
                            Button(action: {menuShown.toggle()}) {
                                Image(systemName: "line.horizontal.3.circle")
                                    .foregroundColor(lightMode ? .black : .white)
                                    .font(.system(size: 30))
                                    .rotationEffect(.degrees(menuShown ? 90 : 0))
                                    .animation(.easeInOut)
                            }
                            
                            if selectedCity.city == "Current Location"  {
                                Spacer()
                                Text(addButtonTapped ? "add" : "\(viewModel.name ?? "")")
                                    .fontWeight(addButtonTapped ? .light : .bold)
                                    .foregroundColor(lightMode ? .black : .white)
                                
                                if viewModel.name != nil {
                                    Text(addButtonTapped ? "" : ",")
                                        .fontWeight(addButtonTapped ? .light : .bold)
                                        .foregroundColor(lightMode ? .black : .white)
                                }
                                
                                Text(addButtonTapped ? "city" : "\(viewModel.country ?? "")")
                                    .fontWeight(addButtonTapped ? .bold : .light)
                                    .foregroundColor( lightMode ? .black : .white)
                                
                                Spacer()
                            } else {
                                Spacer()
                                Text(addButtonTapped ? "add" : "\(selectedCity.city )")
                                    .fontWeight(addButtonTapped ? .light : .bold)
                                    .foregroundColor(lightMode ? .black : .white)
                                
                                if viewModel.name != nil {
                                    Text(addButtonTapped ? "" : ",")
                                        .fontWeight(addButtonTapped ? .light : .bold)
                                        .foregroundColor(lightMode ? .black : .white)
                                }
                                
                                Text(addButtonTapped ? "city" : "\(selectedCity.country )")
                                    .fontWeight(addButtonTapped ? .bold : .light)
                                    .foregroundColor(lightMode ? .black : .white)
                                
                                Spacer()
                            }
                            
                            
                        }
                        .padding()
                        
                    }
                    
                    if addButtonTapped {
                        
                        VStack {
                            VStack {
                                
                                HStack {
//                                    TextField("search city here", text: $searchText)
//                                        .onTapGesture {
//                                            keyboardInUse = true
//                                        }
                                    CustomTextField(placeholder: Text("search for city").foregroundColor(Color(#colorLiteral(red: 0.2834932506, green: 0.2871159315, blue: 0.2869921327, alpha: 1))), text: $searchText)
                                        .onTapGesture {
                                                                                 keyboardInUse = true
                                                                             }
                                    
                                }
                                
                                .padding()
                                
                                .background(Color(#colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)))
                                .cornerRadius(17)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 100)
                                
                                ZStack {
                                    ScrollView {
                                        VStack {
                                            HStack {
                                                Text("Current Location")
                                                    .foregroundColor(searchText.isEmpty ? .white : lightMode ? .black : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                                    .fontWeight(.heavy)
                                                    .padding(.leading, 40)
                                                Spacer()
                                                
                                                
                                            }.padding([.bottom, .top], 30)
                                            
                                            .onTapGesture {
                                                print(coordinate.latitude)
                                                self.viewModel.fetchAllWeather(lat: coordinate.latitude, long: coordinate.longitude)
                                                addButtonTapped = false
                                            }
                                            
                                            ForEach(cities, id: \.self) { city in
                                                HStack {
                                                    
                                                    
                                                    
                                                    Text("\(city.city!), ")
                                                        .foregroundColor(searchText.isEmpty ? .white : lightMode ? .black : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                                        .fontWeight(.bold)
                                                        .padding(.leading, 40)
                                                    
                                                    
                                                    Text("\(city.country!)")
                                                        .foregroundColor(searchText.isEmpty ? .white : lightMode ? .black : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                                    Spacer()
                                                    
                                                    //                                                if searchText.count == 0 {
                                                    Button(action: {
                                                        
                                                        let myIndex = citiesArray.firstIndex(of: city.city!)
                                                        
                                                        delete(index: myIndex ?? -1)
                                                        
                                                        if myIndex != nil {
                                                            citiesArray.remove(at: myIndex!)
                                                        }
                                                        
                                                        
                                                        
                                                        print(citiesArray)
                                                        
                                                    }) {
                                                        Circle()
                                                            .fill(searchText.isEmpty ? Color.red : lightMode ? Color.black : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                                            .frame(width: 35, height: 35)
                                                            .overlay(
                                                                Image(systemName: "xmark")
                                                                    .font(.system(size: 15))
                                                                    .foregroundColor(searchText.isEmpty ? .white : .black)
                                                            )
                                                            .padding(.horizontal)
                                                            .padding(.trailing)
                                                    }
                                                    //                                                }
                                                    
                                                    
                                                    
                                                    //                                                Text("\(0)°")
                                                    //                                                    .foregroundColor(searchText.isEmpty ? .white : .black)
                                                    //                                                    .fontWeight(.bold)
                                                    //                                                    .font(.title3)
                                                    //                                                    .padding(.trailing, 40)
                                                }
                                                .padding(.bottom, 30)
                                                
                                                //                                            .onAppear {
                                                //                                                viewModel.fetchOneCityWeather(city: city.city.lowercased())
                                                //                                            }
                                                .onAppear {
                                                    if citiesArray.firstIndex(of: city.city!) == nil {
                                                        citiesArray.insert(city.city!, at: 0)
                                                        citiesArray.sort()
                                                    }
                                                    
                                                    print(coordinate.longitude)
                                                }
                                                .onTapGesture {
                                                    
                                                    //                                                selectedCity = city
                                                    
                                                    print(city.city!)
                                                    
                                                    
                                                    
                                                    self.viewModel.fetchAllWeather(lat: city.lat, long: city.lng)
                                                    
                                                    
                                                    
                                                    
                                                    addButtonTapped = false
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                //                                            Spacer()
                                                
                                                
                                                
                                                
                                            }.padding(.top, 30)
                                        }
                                    }
                                    
                                    if searchText.count >= 3 {
                                        ScrollView {
                                            
                                            ForEach(fetcher.cities.filter({"\(String(describing: $0.city))".contains(searchText)}), id: \.self) { city in
                                                
                                                
                                                HStack {
                                                    Text("\(city.city ?? ""), \(city.country ?? "")")
                                                        .foregroundColor(.white)
                                                    Spacer()
                                                        
                                                        
                                                        .padding()
                                                }
                                                .background(lightMode ? Color.black : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                                .padding(.horizontal, 40)
                                                .onTapGesture {
                                                    searchText = ""
                                                    keyboardInUse = false
                                                    self.hideKeyboard()
                                                    
                                                    //                                                    citiesArray.append(city.city!)
                                                    
                                                    if citiesArray.firstIndex(of: city.city!) == nil {
                                                        citiesArray.insert(city.city!, at: 0)
                                                        citiesArray.sort()
                                                        let newCity = City(context: viewContext)
                                                        newCity.city = city.city!
                                                        newCity.country = city.country!
                                                        newCity.lat = city.lat!
                                                        newCity.lng = city.lng!
                                                        
                                                        saveContext()
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
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
                        .frame(width: UIScreen.main.bounds.width - 15, height: keyboardInUse ? 450 : UIScreen.main.bounds.height - 300)
                        .transition(AnyTransition.opacity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(lightMode ? .black : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .shadow(color: lightMode ? Color.black : Color(#colorLiteral(red: 0.7597532258, green: 0.7597532258, blue: 0.7597532258, alpha: 1)), radius: 10, x: 0, y: 0)
                                //                .padding(.top, 50)
                                .padding(.horizontal, 10)
                                
                                
                        )
                    } else {
                        
                        
                        VStack {
                            
                            
                            HStack(alignment: .center) {
                                Image(systemName: "\(returnWeatherIcon(id: viewModel.currentWeather?.weather.first?.id ?? -1))")
                                    
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
                                Text("\(viewModel.currentWeather?.weather.first!.description ?? "clear")")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .minimumScaleFactor(0.5)
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
                                .fill(LinearGradient(gradient: returnWeatherColor(id: (viewModel.currentWeather?.weather.first?.id) ?? -1), startPoint: .top, endPoint: .bottom))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
                            
                            
                        ).padding(.bottom, 15)
                        
                        
                        HStack {
                            
                            VStack() {
                                
                                
                                Spacer()
                                
                                Text("\(viewModel.currentWeather?.main.humidity ?? 0)")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                                    .padding()
                                
                                Text("humidity")
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
                                
                            }
                            
                            VStack {
                                
                                
                                
                                Spacer()
                                
                                HStack(spacing: 5) {
                                    Text("\((imperialMode ? Int(viewModel.currentWeather?.wind.speed ?? 0) : mphTokph(mph: viewModel.currentWeather?.wind.speed ?? 0)))")
                                        .font(.system(size: 32, weight: .bold, design: .default))
                                        .foregroundColor(Color(.black))
                                
                             
                                    Text("\(imperialMode ? "mph" : "kph" )")
                                            .font(.caption2)
                                            .lineLimit(1)
                                    
                                    
               
                                 
                                        
                                        .foregroundColor(Color(#colorLiteral(red: 0.4431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)))
                                }.padding()
                                
                                Text("wind")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
                                
                                
                            }
                            
                            VStack {
                                
                                
                                Spacer()
                                
                                Text("\(viewModel.currentTempMax ?? 0)°")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.7215686275, green: 0.3529411765, blue: 1, alpha: 1)))
                                    .padding()
                                
                                Text("high")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                                
                            }
                            
                            VStack {
                                
                                Spacer()
                                
                                Text("\(viewModel.currentTempMin ?? 0)°")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9098039216, green: 0.6549019608, blue: 0.1725490196, alpha: 1)))
                                    .padding()
                                
                                Text("low")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color(#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)))
                                    .padding()
                            }
                            
                        }.frame(width: UIScreen.main.bounds.width - 45, height: 125)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(Color(UIColor(named: "myColor")!))
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
                        )
                        
                        //                        HourlyTemperatureCard()
                        
                        VStack {
                            HStack {
                                Text("today")
                                    .font(.system(size: 23, weight: .semibold, design: .default))
                                    .foregroundColor(lightMode ? .black : .white)
                                    .padding(40)
                                
                                Spacer()
                                
                                Button(action: { showNextWeek = true
                                    self.dismissCard = false
                                    
                                    
                                }) {
                                    HStack {
                                        Text("next 7 days")
                                            .font(.system(size: 17, weight: .semibold, design: .default))
                                            .foregroundColor(.white)
                                        
                                        Image("arrow")
                                    }
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(#colorLiteral(red: 0.8226141334, green: 0.8073855042, blue: 0.8075038195, alpha: 1)))
                                    )
                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 0)
                                    .padding(30)
                                    
                                }
                            }
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Spacer()
                                    ForEach(viewModel.hourlyTemps, id: \.self) { hour in
                                        
                                        
                                        if hour.dt == viewModel.hourlyTemps.first!.dt {
                                            
                                            VStack {
                                                Text("\(epochToTime(epoch: hour.dt))")
                                                    .foregroundColor(Color.white)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "\(returnWeatherIconInverted(id: viewModel.currentWeather?.weather.first?.id ?? -1))")
                                                    .font(Font.largeTitle.weight(.semibold))
                                                    .foregroundColor(Color.white)
                                                    .frame(width: 30, height: 30)
                                                
                                                Spacer()
                                                
                                                Text("now")
                                                    .foregroundColor(Color.white)
                                                    .fontWeight(.semibold)
                                                
                                            }
                                            .padding()
                                            
                                            //                                            .padding(.vertical, 30)
                                            
                                            .background(
                                                RoundedRectangle(cornerRadius: 17)
                                                    .fill(Color(#colorLiteral(red: 0.5861129761, green: 0.2378639579, blue: 0.996984899, alpha: 0.9555174973)))
                                                    .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0, y: 0)
                                                    .frame(minWidth: 100)
                                            )
                                            .padding(15)
                                            
                                            
                                            
                                        } else {
                                            VStack {
                                                Text("\(epochToTime(epoch: hour.dt))")
                                                    .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.4548646212, green: 0.454932034, blue: 0.4548440576, alpha: 1) : .white))
                                                
                                                Spacer()
                                                
                                                Image(systemName: "\(returnWeatherIconInverted(id: viewModel.currentWeather?.weather.first?.id ?? -1))")
                                                    .font(Font.largeTitle.weight(.semibold))
                                                    .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.4548646212, green: 0.454932034, blue: 0.4548440576, alpha: 1) : .white))
                                                    .frame(width: 30, height: 30)
                                                
                                                Spacer()
                                                
                                                Text("\(Int(hour.temp))°")
                                                    .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.4548646212, green: 0.454932034, blue: 0.4548440576, alpha: 1) : .white))
                                                    .fontWeight(.semibold)
                                            }
                                            .padding()
                                            //                                            .padding(.vertical, 10)
                                            
                                            .background(
                                                RoundedRectangle(cornerRadius: 17)
                                                    .fill(Color(lightMode ? #colorLiteral(red: 0.9960234761, green: 0.9898574948, blue: 1, alpha: 1) : #colorLiteral(red: 0.3751846552, green: 0.3739859462, blue: 0.3772246242, alpha: 1)))
                                                    .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0, y: 0)
                                                    .frame(minWidth: 100)
                                            )
                                            .padding(15)
                                        }
                                        
                                        
                                        
                                    }
                                }
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    Spacer()
                    
                    
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            
                            addButtonTapped.toggle()
                            keyboardInUse = false
                            
                        }) {
                            Circle()
                                .fill(addButtonTapped ? lightMode ? .black : .white : lightMode ? Color.white : Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .frame(width: 90, height: 90)
                                .padding(.horizontal)
                                .shadow(color: Color(addButtonTapped ? .black : #colorLiteral(red: 0.7450370193, green: 0.7255315781, blue: 0.7254028916, alpha: 1)), radius: 4, x: 0, y: 0)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color( addButtonTapped ? lightMode ? .white : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : lightMode ?  #colorLiteral(red: 0.7450370193, green: 0.7255315781, blue: 0.7254028916, alpha: 1) : .white) )
                                        .font(.system(size: 35, weight: .bold, design: .rounded))
                                        
                                        .rotationEffect(.degrees(addButtonTapped ? 0 : 135))
                                )
                                .animation(.easeInOut)
                        }
                        
                    }
                    
                    
                    
                }
            }
            .onAppear(perform: {
                
                //                if coordinate.latitude == 0.0 {
                //                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                //                        print(coordinate.latitude)
                //                        self.viewModel.fetchAllWeather(lat: coordinate.latitude, long: coordinate.longitude)
                //                        print("watied 1 second")
                //                    }
                //                }
                //e
                //                print(coordinate.latitude)
                //                self.viewModel.fetchAllWeather(lat: coordinate.latitude, long: coordinate.longitude)
                //                addButtonTapped = false
                //
                //                viewModel.fetchAllWeather(lat: coordinate.latitude, long: coordinate.longitude)
                //
                //                print(coordinate.latitude)
                //
                //                print("ON APPEAR")
                
                var lat = locationManager.location?.coordinate.latitude
                var long = locationManager.location?.coordinate.longitude
                
                if long == nil && lat == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        
                        if long == nil && lat == nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                
                                lat = locationManager.location?.coordinate.latitude
                                long = locationManager.location?.coordinate.longitude
                                
                                self.viewModel.fetchAllWeather(lat: lat ?? 0, long: long ?? 0)
                            }
                        } else {
                            
                            
                            self.viewModel.fetchAllWeather(lat: lat!, long: long!)
                        }
                        
                        
                        lat = locationManager.location?.coordinate.latitude
                        long = locationManager.location?.coordinate.longitude
                        
                        self.viewModel.fetchAllWeather(lat: lat ?? 0, long: long ?? 0)
                    }
                } else {
                    
                    
                    self.viewModel.fetchAllWeather(lat: lat!, long: long!)
                }
                
                
                
                
                
                
                
            })
            .padding(.horizontal, 30)
            
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 50, height: 5)
                        .onTapGesture {
                            showNextWeek = false
                        }
                    
                    Spacer()
                }
                
                HStack {
                    Text("next week forcast")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                        .padding(.horizontal)
                        .onTapGesture {
                            showNextWeek = false
                        }
                    Spacer()
                }
                .padding(.vertical, 30)
                
                ScrollView {
                    VStack {
                        
                        if viewModel.dailyWeather != nil {
                            
                            ForEach(viewModel.dailyWeather!, id: \.self) { daily in
                                HStack {
                                    Image(systemName: returnWeatherIcon(id: daily.weather[0].id))
                                        .font(.system(size: 30, weight: .light, design: .rounded))
                                        .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : .white))
                                    Text("\(epochToDayName(epoch: daily.dt).lowercased())")
                                        .padding(.horizontal)
                                        .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : .white))
                                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    Spacer()
                                    Text("\(Int(daily.temp.max))°")
                                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                                            .foregroundColor(Color(lightMode ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : .white))
                                    Text("\(Int(daily.temp.min))°")
                                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(#colorLiteral(red: 0.7347081304, green: 0.8017949462, blue: 0.8352752328, alpha: 1)))
                                }
                                .padding(20)
                                .padding(.vertical, 10)
                                .background(lightMode ? Color.white : Color.black)
                                if lightMode {
                                    Divider()
                                }
                          
                                    
                            }
                            .opacity(dismissCard ? 0.3 : 1)

                            
                        }
                        
                        
                        
                        
                        
                    }
                    .padding(.bottom, 50)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(
                        Color.white.opacity(dismissCard ? 0.2 : 1)
                        
                        
                    )
                    
                }
                .onTapGesture {
                    showNextWeek = false
                }
                
                
                
                
                Spacer()
                
            }
            .padding(30)
            .background(
                
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(dismissCard ? #colorLiteral(red: 0.2613917291, green: 0.6402744055, blue: 0.9006297588, alpha: 0.6237081566) : #colorLiteral(red: 0.2613917291, green: 0.6402744055, blue: 0.9006297588, alpha: 1)))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
                
                
            )
            .offset(y: showNextWeek ? self.draggedOffset.height + 50 : 1000)
            .gesture(DragGesture()
                        .onChanged { value in
                            
                            if value.translation.height > -10 {
                                self.draggedOffset = value.translation
                            }
                            if value.translation.height > 50 {
                                self.dismissCard = true
                            } else {
                                self.dismissCard = false
                                
                            }
                            
                        }
                        .onEnded { value in
                            
                            if value.translation.height > 365 {
                                showNextWeek = false
                                
                                self.draggedOffset = CGSize.zero
                            } else {
                                self.draggedOffset = CGSize.zero
                                self.dismissCard = false
                                
                            }
                            
                        }
                     
                     
            )
            .animation(.spring())
            
            
            
            
            
            
        }
        .scaleEffect(menuShown ? 0.8 : 1)
        .offset(x: menuShown ? 200 : 0)
        .animation(.easeInOut(duration: 0.2))
     
        
        }

        
        
    }
    
    func delete(index: Int) {
        
        if index == -1 {
            return
        } else {
            let deletedCity = cities[index]
            viewContext.delete(deletedCity)
            
            saveContext()
        }
    }
    
    
    
    func epochToTime(epoch: Int) -> String {
        
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(epoch))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        var dateString = dateFormatter.string(from: date as Date)
        
        dateString = dateString.replacingOccurrences(of: ":00", with: "")
        
        if dateString.first == "0" {
            dateString.remove(at: dateString.startIndex)
        }
        
        
        
        return dateString
    }
    
    func epochToDayName(epoch: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(epoch))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date as Date)
    }
    
    func mphTokph(mph: Double) -> Int {
        return Int(mph * 1.609)
    }
    
    
    
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .foregroundColor(.black)
        }
    }
}



#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

func returnWeatherIcon(id: Int) -> String {
    switch id {
    case 200...299:
        return "cloud.bolt.rain.fill"
    case 300...399:
        return "cloud.drizzle.fill"
    case 500...599:
        return "cloud.heavyrain.fill"
    case 600...699:
        return "cloud.snow.fill"
    case 700...799:
        return "smoke.fill"
    case 800:
        return "cloud"
    case 801...804:
        return "cloud.fill"
    default:
        return "sun.max.fill"
    }
}

func returnWeatherIconInverted(id: Int) -> String {
    switch id {
    case 200...299:
        return "cloud.bolt.rain"
    case 300...399:
        return "cloud.drizzle"
    case 500...599:
        return "cloud.heavyrain"
    case 600...699:
        return "cloud.snow"
    case 700...799:
        return "smoke"
    case 800:
        return "cloud"
    case 801...804:
        return "cloud"
    default:
        return "sun.max"
    }
}

func returnWeatherColor(id: Int) -> Gradient {
    switch id {
    case 200...232:
        return ColorPalettes[0]
    case 300...321:
        return ColorPalettes[0]
    case 500...531:
        return ColorPalettes[0]
    case 600...622:
        return ColorPalettes[0]
    case 800:
        return ColorPalettes[0]
    case 801...804:
        return ColorPalettes[0]
    default:
        return ColorPalettes[0]
    }
}

