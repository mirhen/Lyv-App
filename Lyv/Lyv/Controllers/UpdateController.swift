//
//  BeaconController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import CoreLocation

class UpdateController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton! {
        didSet {
            if imageButton.imageView != nil {
                imageButton.imageView!.layer.cornerRadius = imageButton.frame.width/2
            }
        }
    }
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    
    //Properties
    var beacon: Beacon?
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    private let tintColor = UIColor(hexString: "#DD54DF")
    private let backgroundColor: UIColor = .white
    private let textFieldColor: UIColor = .black
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.init(name: "Avenir-Book", size: 15) ?? UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.init(name: "Avenir-Roman", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
    
    @IBAction func distanceSliderSlided(_ sender: Any) {
        distanceLabel.text = "\(Int(distanceSlider.value)) Miles"
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            
            self.imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .highlighted)
            
            
            
        }
    }
    
    @IBAction func launchButtonPressed(_ sender: Any) {
        updateBeacon()
    }
    
  
    @IBAction func removeButtonPressed(_ sender: Any) {
        if let beacon = beacon {
            BeaconService.removeBeacon(forBeacon: beacon)
        }
        performSegue(withIdentifier: "exitToProfile", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        hideKeyboardWhenTappedAround()
        setupLocationManager()
        // Do any additional setup after loading the view.
    }
    
    func updateBeacon() {
        if nameTextField.text == "" {
            showAlert(withMessage: "Please add a title for your beacon")
        } else if !CLLocationManager.locationServicesEnabled() {
            showAlert(withMessage: "Enable location services in Setting to add a beacon")
        } else {
            
            //figure out how to store image data
            if let title = nameTextField.text {
                let description = descriptionTextField.text ?? ""
                
                let jpg = imageButton.imageView?.image?.jpegData(compressionQuality: 0.5) ?? UIImage(named: "LocationPin")!.jpegData(compressionQuality: 0.5)
                print(jpg!.count)
                
                
                let newBeacon = Beacon(title: title, uid: User.current.uid, date: Date(), distance: Int(distanceSlider!.value), description: description, imageData: jpg!, latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude))
                
                if let beacon = self.beacon {
                    newBeacon.key = beacon.key
                }
                
                BeaconService.updateBeacon(forBeacon: newBeacon)
                UserService.updateUserValues(User.current)
                performSegue(withIdentifier: "exitToProfile", sender: self)
            }
        }
    }
    
    func setupUI() {
        
        if let beacon = beacon {
            nameTextField.text = beacon.title
            descriptionTextField.text = beacon.description
            distanceSlider.setValue(Float(beacon.distance), animated: true)
            distanceLabel.text = "\(Int(beacon.distance)) Miles"
            imageButton.setImage(UIImage(data: beacon.imageData), for: .normal)
        }
        
        launchButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: LyvColors.darkpurple)
        
        removeButton.configure(color: LyvColors.darkpurple,
                               font: buttonFont,
                               cornerRadius: 25,
                               backgroundColor: .white)
        removeButton.addBorder(1, color: LyvColors.darkpurple)
        
        nameTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 40/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
        nameTextField.clipsToBounds = true
        nameTextField.autocorrectionType = .no
        
        descriptionTextField.configure(color: textFieldColor,
                                       font: textFieldFont,
                                       cornerRadius: 40/2,
                                       borderColor: textFieldBorderColor,
                                       backgroundColor: backgroundColor,
                                       borderWidth: 1.0)
        descriptionTextField.clipsToBounds = true
        descriptionTextField.autocorrectionType = .no
        
        imageButton.addBorder(2, color: LyvColors.darkpurple)
        imageButton.layer.cornerRadius = imageButton.frame.size.width / 2
        imageButton.imageView!.clipsToBounds = true
        
        
    }
}

extension UpdateController: CLLocationManagerDelegate {
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

