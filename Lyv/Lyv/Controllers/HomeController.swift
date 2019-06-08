//
//  HomeController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import SceneKit
//import ARKit
import CoreLocation
import ARCL
import Kingfisher

var currentLocation = CLLocation(coordinate: CLLocationCoordinate2D(), altitude: 0)

class HomeController: UIViewController {

    //IBOutlets
//    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addBeaconButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var frameSwitch: UISwitch!
    
    //Properties
    var beacons: [Beacon] = []
    var selectedBeacon: Beacon?
    var sceneLocationView = SceneLocationView()
    var nodes: [LocationAnnotationNode] = []
    //Location Property
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toProfileController", sender: self)
    }
    @IBAction func exitToHome(segue: UIStoryboardSegue) { }
    
    @objc func switchPressed(switchState: UISwitch) {
        
        self.sceneLocationView.removeAllNodes()
        beacons.forEach {
            let node = $0.creatAnnotationNode(withLine: frameSwitch.isOn, currentLocation: CLLocation(coordinate: coordinate, altitude: 0))
            
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        //        sceneView.delegate = self
        setupUI()
        
        
        // Set up Location Manager
        setupLocationManager()
        
//        let beacon = Beacon(title: "Test", uid: "hi", date: Date(), distance: 5, description: "Hi", imageData: UIImage(named: "LocationPin")!.jpegData(compressionQuality: 0.5)!, latitude: 31.779162185296208, longitude: 35.2)
//        let node = beacon.creatAnnotationNode()
//        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up Core Location
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        BeaconService.beacons { (beacons) in
            self.beacons = beacons
            beacons.forEach {
                let node = $0.creatAnnotationNode(currentLocation: CLLocation(coordinate: self.coordinate, altitude: 0))
                
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
                
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        sceneLocationView.pause()
//        sceneLocationView.removeFromSuperview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds

        view.bringSubviewToFront(addBeaconButton)
        view.bringSubviewToFront(profileButton)
        view.bringSubviewToFront(frameSwitch)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsController" {
            let destination = segue.destination as! DetailsController
            if let beacon = selectedBeacon {
                destination.beacon = beacon
            }
        } else if segue.identifier == "toProfileController" {
            let destination = segue.destination as! ProfileController
            destination.beacons = beacons.filter {$0.uid == User.current.uid }
        }
    }
    
    func setupUI() {
        
        addBeaconButton.configure(color: .white,
                              font: UIFont.systemFont(ofSize: 20),
                              cornerRadius: 55/2,
                              backgroundColor: LyvColors.darkpurple)
        
        if User.current.profileURL != "?width=300&height=300" {
            let imageURL = URL(string: User.current.profileURL)
            profileButton.clipsToBounds = true
            profileButton.kf.setImage(with: imageURL, for: .normal)
        }
        profileButton.addBorder(1, color: LyvColors.lightpink)
        profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
        
        frameSwitch.addTarget(self, action: #selector(switchPressed), for: .valueChanged)
    }

    
    
    // Touch events on nodes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneLocationView)
            
            let hitResults = sceneLocationView.hitTest(touchLocation, options: [.boundingBoxOnly : true])
            for result in hitResults {
                
                print("HIT:-> Name: \(result.node.description)")
                print("HIT:-> description  \(result.node.name)")
//                result.node.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
                
                beacons.forEach {
                    if result.node.name! == $0.title {
                        self.selectedBeacon = $0
                        performSegue(withIdentifier: "toDetailsController", sender: self)
                        return
                    }
                }
                
            }
        }
    }
    
}

extension HomeController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.startUpdatingLocation()
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            currentLocation = location
            self.coordinate = location.coordinate
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showAlert(withMessage: "Please allow location access to create beacons and see nearby beacons")
        }
    }
}

// MARK: - SceneLocationViewDelegate
@available(iOS 11.0, *)
extension HomeController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        print("7845768")
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        print("546456")
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
    }
}
