//
//  Home.swift
//  PicMe
//
//  Created by Tejas Maraliga on 1/19/22.
//

import SwiftUI
import CoreLocation
import Drawer

struct Home: View {
    @StateObject var mapData = MapViewModel()
    
    @State var locationManager = CLLocationManager()

    @FocusState private var emailFieldIsFocused: Bool

    
    var body: some View {
        ZStack {
            //MapView
            MapView().environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            VStack{
                VStack(spacing: 0){
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search", text: $mapData.searchText)
                            .colorScheme(.light)
                            .focused($emailFieldIsFocused)
                            
                    }.padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.white)
                    
                    if !mapData.places.isEmpty && mapData.searchText != "" {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(mapData.places) {place in
                                    HStack{
                                        Image(systemName: "location.fill").foregroundColor(.black).padding(.leading)
                                        Text(place.place.name ?? "")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                    }.onTapGesture {
                                        emailFieldIsFocused = false
                                        mapData.selectPlace(place: place)
                                    }
                                    Divider()
                                }
                            }.padding(.top)
                            
                        }.background(Color.white)
                    }
                }.padding()
                Spacer()
            }
            Drawer {
                ZStack {
                    
                    BlurredView(style: .systemThinMaterial)
                    VStack{
                        Capsule()
                            .frame(width: 100, height: 7)
                            .padding(.top, 7)
                        
                        ScrollView {
                            VStack() {
                                ForEach(0..<15) {_ in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5).padding(.leading, 10).padding(.trailing, 10).foregroundColor(.blue)
                                        VStack{
                                            Text("Hello")
                                            Text("Hello")
                                            Text("Hello")
                                            Text("Hello")
                                        }
                                    }.padding(.bottom, 50)
                                    
                                }
                            }
                        }.padding(.top, 25).padding(.leading, 50).padding(.trailing, 50)

                    }
                }
            }.rest(at: .constant([100, 340, UIScreen.main.bounds.height - 150]))
                .edgesIgnoringSafeArea(.vertical)
            
            
            
            
        }.onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission Denied"), message:
              Text("Please enable location permission in settings"),
              dismissButton: .default(Text("Go To Settings"),
                action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchText, perform: {value in
            let delay = 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchText {
                    //Search
                    self.mapData.searchQuery()
                }
            }
            
        })
            
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
