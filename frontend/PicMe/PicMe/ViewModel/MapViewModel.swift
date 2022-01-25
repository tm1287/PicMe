//
//  MapViewModel.swift
//  PicMe
//
//  Created by Tejas Maraliga on 1/19/22.
//

import SwiftUI
import MapKit
// Map Data

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    struct Photographers: Codable {
        var photographers: [PhotographerPin]
    }
    
    struct PhotographerPin: Codable {
        var latitude: Double
        var longitude: Double
        var name: String
    }
    
    @Published var mapView = MKMapView()
    
    @Published var region:MKCoordinateRegion!
    
    @Published var permissionDenied = false
    
    @Published var mapType: MKMapType = .standard
    
    @Published var searchText = ""
        
    @Published var places: [Place] = []
        
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func fetchNearbyPhotographers(coordinate: CLLocationCoordinate2D) {
        print("Fetchin!!!")
                
        mapView.removeAnnotations(mapView.annotations)

        let url = "http://192.168.0.176:5000/photographer"
                
        let parameters = ["latitude": String(coordinate.latitude), "longitude": String(coordinate.longitude)] as [String: String]
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    //data: Data -> struct using codeable
                    let res = try JSONDecoder().decode(Photographers.self, from:data!)
                    
                    print(res.photographers)
                    
                    res.photographers.forEach { photographer in
                        let photographerAnnotation = MKPointAnnotation()
                        photographerAnnotation.coordinate = CLLocationCoordinate2D(latitude: photographer.latitude, longitude: photographer.longitude)
                        photographerAnnotation.title = photographer.name
                        
                        self.mapView.addAnnotation(photographerAnnotation)

                    }
                    
                    


                } catch {
                    print(error)
                }
            }
            
        }
        
        dataTask.resume()
        
        /*sendRequest("http://192.168.0.176:5000/photographer", parameters: ["latitude": String(coordinate.latitude), "longitude": String(coordinate.longitude)]) { [self] responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            // use `responseObject` here
            
            print(responseObject)
            print(type(of: responseObject))
        }*/
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Runs when the location manager state changes
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            permissionDenied.toggle()
        case .denied:
            permissionDenied.toggle()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        
        fetchNearbyPhotographers(coordinate: location.coordinate)
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    //Used to execute the search query from the search bar.
    func searchQuery() {
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else{return}
            
            self.places = result.mapItems.compactMap({(item) -> Place? in
                return Place(place: item.placemark)
            })
        }
        
    }
    
    //Runs when the location is selected from the search bar.
    func selectPlace(place: Place) {
        searchText = ""
        guard let coordinate = place.place.location?.coordinate else {return}
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No Name"
        
        //Query backend for nearby photographers
        //Modify photographer state
        fetchNearbyPhotographers(coordinate: coordinate)
        
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
}
