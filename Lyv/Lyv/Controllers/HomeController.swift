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

class HomeController: UIViewController {

    //IBOutlets
//    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addBeaconButton: UIButton!
    
    //Properties
    var beacons: [Beacon] = []
    var sceneLocationView = SceneLocationView()
    
    //Location Property
    let locationManager = CLLocationManager()
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func exitToHome(segue: UIStoryboardSegue) { }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        //        sceneView.delegate = self
        
        // Set up Location Manager
        setupLocationManager()
        
        // Set up Core Location
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        // Show statistics such as fps and timing information
        //        sceneView.showsStatistics = true
        
        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //        sceneView.scene = scene
        

    }
    override func viewWillAppear(_ animated: Bool) {
        BeaconService.beacons { (beacons) in
            beacons.forEach {
                let node = $0.creatAnnotationNode()
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds

        view.bringSubviewToFront(addBeaconButton)
        
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView.session.pause()
//    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
    
    
    // Touch events on nodes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneLocationView)
            
            let hitResults = sceneLocationView.hitTest(touchLocation, options: [.boundingBoxOnly : true])
            for result in hitResults {
                
                print("HIT:-> Name: \(result.node.description)")
                print("HIT:-> description  \(result.node.name)")
                
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
            print("User Location: Latitude - ", location.coordinate.latitude, " Longitude - ", location.coordinate.longitude)
            
            
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
