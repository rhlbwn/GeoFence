//
//  ViewController.swift
//  GeoFence
//
//  Created by Rahul Bawane on 10/04/21.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

let REGION_IDENTIFIER = "GeoFence"

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        if self.locationManager.authorizationStatus == .authorizedAlways {
            mapView.showsUserLocation = true
            setupRegion()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction func printCoreData(_ sender: Any) {
        fetchRecords()
    }
    
    func fetchRecords() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entryRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EnteringRegion")
        let exitRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExitingRegion")
        entryRequest.returnsObjectsAsFaults = false
        exitRequest.returnsObjectsAsFaults = false

        do {
            print("Entry Records")
            let entryResult = try context.fetch(entryRequest)
            for data in entryResult as! [NSManagedObject] {
                let lat = data.value(forKey: "latitude") as! Double
                let long = data.value(forKey: "longitude") as! Double
                let time = data.value(forKey: "time") as! String
                print("Latitude: \(lat); Longitude: \(long); Time: \(time)")
            }
            
            print("Exit Records")
            let exitResult = try context.fetch(exitRequest)
            for data in exitResult as! [NSManagedObject] {
                let lat = data.value(forKey: "latitude") as! Double
                let long = data.value(forKey: "longitude") as! Double
                let time = data.value(forKey: "time") as! String
                print("Latitude: \(lat); Longitude: \(long); Time: \(time)")
            }
        } catch {
            print("Failed")
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    //MARK: - Location manager delegates
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedAlways {
            mapView.showsUserLocation = true
            setupRegion()
          } else {
            let message = "Please enable location as always authorized"
            showAlert(withTitle: "Warning", message: message)
          }
    }
    
    func setupRegion() {
        let region =  CLCircularRegion(center: CLLocationCoordinate2D(latitude: 19.017615, longitude: 72.856164), radius: 10, identifier: REGION_IDENTIFIER)
        region.notifyOnEntry = true
        region.notifyOnExit = true

        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
          showAlert(withTitle: "Error", message: "Geofencing is not supported on this device!")
          return
        }
        self.locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring() {
      for region in locationManager.monitoredRegions {
        guard
          let circularRegion = region as? CLCircularRegion,
          circularRegion.identifier == REGION_IDENTIFIER
        else { continue }

        locationManager.stopMonitoring(for: circularRegion)
      }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension UIViewController {
  func showAlert(withTitle title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}


