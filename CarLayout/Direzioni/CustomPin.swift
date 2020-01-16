//
//  CustomPin.swift
//  CarLayout
//
//  Created by Davide Vitiello on 09/12/2019.
//  Copyright © 2019 Davide Vitiello. All rights reserved.
//

import Foundation
import MapKit

class customPin: NSObject, MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    
    }
}
