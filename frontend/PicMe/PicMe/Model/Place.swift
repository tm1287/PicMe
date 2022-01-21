//
//  Place.swift
//  PicMe
//
//  Created by Tejas Maraliga on 1/20/22.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var place: CLPlacemark
}
