//
//  MapViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 03/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak private var mapView: MKMapView!

    var restaurant: RestaurantMO!
    let markName = "MyMarker"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMap()
        setMapViewAtributes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setBackButtonTintColor(mycolor: .black)
    }

    private func setMapViewAtributes() {
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsCompass = true
    }

    private func setUpMap() {
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler: { placemarks, error in
            if let error = error {
                print(error)

                return
            }
            if let placemark = placemarks?[0] {
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type

                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
}
extension MapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let markIdentifier = markName
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: markIdentifier) as? MKMarkerAnnotationView

        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: markIdentifier)
        }

        annotationView?.glyphText = "🍽"
        annotationView?.markerTintColor = UIColor.red

        return annotationView
    }
}
