//
//  StoreLocatorViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit
import MapKit

class StoreLocatorViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableviewStore: UITableView!
    var loaderView: UIView?
    
    //MARK:-
    lazy var viewModel: StoreLocatorViewModel = StoreLocatorViewModel()
    static func loadFromNib() -> UIViewController {
        return StoreLocatorViewController(nibName: "StoreLocatorViewController", bundle: nil)
    }
    let store = ["Ruby Office": "Dadar", "Prabhadevi Office": "Parel", "Neosoft Center":"Rabale", "Hingewadi Estate": "Pune", "Pride Parmar Galaxy": "Pune", "NTPL SEZ (Blueridge)": "Pune"]
    
    struct Location {
        let title: String
        let subtitle: String
        let latitude: Double
        let longitude: Double
    }
    let locations = [Location(title: "Ruby Office", subtitle: "Dadar", latitude: 19.021324, longitude: 72.842411),
                     Location(title: "Prabhadevi Office", subtitle: "Parel", latitude: 19.015846, longitude: 72.827995),
                     Location(title: "Neosoft Center", subtitle: "Rabale", latitude: 19.143141, longitude: 73.012268),
                     Location(title: "Hingewadi Estate", subtitle: "Pune", latitude: 18.589700, longitude: 73.743202),
                     Location(title: "Pride Parmar Galaxy", subtitle: "Pune", latitude: 18.589800, longitude: 73.743202),
                     Location(title: "NTPL SEZ (Blueridge)", subtitle: "Pune", latitude: 18.589800, longitude: 73.733202)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewStore.delegate = self
        tableviewStore.dataSource = self
        
        self.tableviewStore.register(UINib(nibName: "StoreLocatorTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreLocator")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let Location = CLLocationCoordinate2D(latitude: 19.021324, longitude: 72.842415)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: Location, span: span)
        mapView.setRegion(region, animated: true)
        self.showLoader(view: self.view, aicView: &self.loaderView)
        //MARK:- setUpNavBar
        setUpNavBar()
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.subtitle = location.subtitle
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Store Locator"
    }
}

extension StoreLocatorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //   return store.keys.count
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreLocator", for: indexPath) as! StoreLocatorTableViewCell
        cell.configureStoreLocator(title: ("\(Array(store.keys)[indexPath.row])"), subtitle: ("\(Array(store.values)[indexPath.row])"))
        self.hideLoader(viewLoaderScreen: self.loaderView)
        return cell
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
