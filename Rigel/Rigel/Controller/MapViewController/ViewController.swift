//
//  ViewController.swift
//  Rigel
//
//  Created by Javed Multani on 22/10/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//
import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController : UIViewController {
    var myRoute : MKRoute?
    var directionsRequest = MKDirections.Request()//MKDirectionsRequest()
     var placemarks = [MKMapItem]()
    
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
//    @IBOutlet var mapView: UIMapView!
//    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       
     
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.handleMapSearchDelegate = self

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        mapView.delegate = self
    }
    
    @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension ViewController : CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
//        let point1 =  CLLocationCoordinate2DMake(18.800387259490215, 73.0497493268922);
//        let point2 = CLLocationCoordinate2DMake(22.504621058068153,  75.27757294010371);
//           
//        var placemarkSource = MKPlacemark(coordinate: point1, addressDictionary: nil)
        placemarks.append(MKMapItem(placemark: placemark))
      
       /*    let points: [CLLocationCoordinate2D]
           points = [point1, point2]

        let geodesic = MKPolyline(coordinates: points, count: 2)
   
        mapView.addOverlay(geodesic)*/
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
       
        
        for (k, item) in placemarks.enumerated() {
            if k < (placemarks.count - 1) {
                directionsRequest.source = item
                directionsRequest.destination = placemarks[k+1]
//                directionsRequest.setSource(item)
//                directionsRequest.setDestination(placemarks[k+1])
                var directions = MKDirections(request: directionsRequest)
//                directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
//                    if error == nil {
//                        self.myRoute = response.routes[0] as? MKRoute
//                        self.mapView.addOverlay(self.myRoute?.polyline)
//                    }
//                }
                
                directions.calculate { (response:MKDirections.Response!, error: Error!) -> Void in
                    if error == nil {
                        self.myRoute = response.routes[0] as? MKRoute
                        //self.mapView.addOverlay(self.myRoute?.polyline)
                        let geodesic:MKPolyline = self.myRoute!.polyline
                        self.mapView.addOverlay(geodesic)
                    }
                }

            }
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05) //MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension LocationSearchTable {
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            let placemarkSource = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
            placemarks.append(MKMapItem(placemark: placemarkSource))
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self){
                var polylineRenderer = MKPolylineRenderer(overlay: overlay)
                polylineRenderer.fillColor = UIColor.blue
                polylineRenderer.strokeColor = UIColor.blue
                polylineRenderer.lineWidth = 2
            
            return polylineRenderer
     }
        return MKOverlayRenderer(overlay: overlay)
    }

}
