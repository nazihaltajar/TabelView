//
//  RestaurantDetailMapCell.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 02/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    @IBOutlet weak private var mapView: MKMapView!

    func configure(location: String) {
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let placemark = placemarks?[0] {
                let annotation = MKPointAnnotation()

            if let location = placemark.location {
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: false)
                }
            }
        })
    }
}
