//
//  Home.swift
//  PicMe
//
//  Created by Tejas Maraliga on 1/19/22.
//

import SwiftUI
import CoreLocation

struct Home: View {
    @StateObject var mapData = MapViewModel()
    
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        ZStack{
            //MapView
            MapView().environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
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
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
