//
//  ViewController.swift
//  DrawRouteOnMapKit
//
//  Created by Aman Aggarwal on 08/03/18.
//  Copyright © 2018 Aman Aggarwal. All rights reserved.
//

import UIKit
import MapKit



class MappaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        posizioneAttuale.latitude = locValue.latitude
        posizioneAttuale.longitude = locValue.longitude
        self.mappa.userTrackingMode = .followWithHeading
        
        //let region = MKCoordinateRegion(center: posizioneAttuale, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //self.mappa.setRegion(region, animated: true)
    }
    
    
    
    @IBOutlet var mappa: MKMapView!
    var pinAttuale: MKAnnotationView!
    
    let locationManager = CLLocationManager()
    var posizioneAttuale = CLLocationCoordinate2D()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            mappa.showsUserLocation = true
            mappa.userTrackingMode = .followWithHeading
        }
        self.hideKeyboardWhenTappedAround() 
        
        

        
        self.mappa.delegate = self
        
        
        // https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names#overview
        //let a = CLLocation(coordinate: posizioneAttuale, altitude: CLLocationDistance(exactly: 0)!, horizontalAccuracy: CLLocationAccuracy(exactly: 0)!, verticalAccuracy: CLLocationAccuracy(exactly: 0)!, timestamp: Date(timeIntervalSince1970: 1000));
        
        //let b = CLGeocoder()
        
        
        
        //b.reverseGeocodeLocation(a, completionHandler: <#T##CLGeocodeCompletionHandler##CLGeocodeCompletionHandler##([CLPlacemark]?, Error?) -> Void#>)
        
        
        

    }
    

    
    //MARK:- MapKit delegates

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.cyan
        renderer.lineWidth = 4.0
        return renderer
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func chiudiSelf()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var textAreaDestinazione: UITextView!
    @IBAction func bottoneAndiamoPremuto(_ sender: Any) {
        
        let dest = textAreaDestinazione.text!
        
        if(dest == "")
        {
            let ab = UIAlertController(title: "OH", message: "Dimmelo n do cazzo vuoi andare pero fra", preferredStyle: .alert)
            
            let azione = UIAlertAction(title: "Sorry Bro", style: .cancel, handler: nil)
            
            ab.addAction(azione)
            self.present(ab, animated: true)
            return
        }

        let coordinate = NetworkManagerRequests.fetchNomePosto(sito: NetworkManagerRequests.sitoMappe + "?nome=\(dest)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        if coordinate == nil
        {
            let ab = UIAlertController(title: "OHCCAZZO", message: "Fra abbiamo un problemino con gli amici di google, oppure hai inserito te il posto, oppure non esiste, oppure idk va bene?", preferredStyle: .alert)
            
            let azione = UIAlertAction(title: "Va bene", style: .cancel, handler: nil)
            
            ab.addAction(azione)
            self.present(ab, animated: true)
            return
        }
        
        let co = CLLocationCoordinate2D(latitude: coordinate!.latitudine, longitude: coordinate!.longitudine)
        
        naviga(postoDestinazione: co)
        
        print("a")
        
    }
    
    func naviga(postoDestinazione: CLLocationCoordinate2D)
    {
        mappa.removeAnnotations(mappa.annotations)
        mappa.removeOverlays(mappa.overlays)
        let postoPartenza = self.posizioneAttuale
        let postoDestinazione = postoDestinazione
        
        let pinPartenza = customPin(pinTitle: "Partenza", pinSubTitle: "", location: postoPartenza)
        let pinDestinazione = customPin(pinTitle: "Arrivo", pinSubTitle: "", location: postoDestinazione)
        self.mappa.addAnnotation(pinPartenza)
        self.mappa.addAnnotation(pinDestinazione)
    
        let sourcePlaceMark = MKPlacemark(coordinate: postoPartenza)
        let destinationPlaceMark = MKPlacemark(coordinate: postoDestinazione)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            
            self.mappa.addOverlay(route.polyline, level: .aboveRoads)
           
            let rect = route.polyline.boundingMapRect
            self.mappa.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
