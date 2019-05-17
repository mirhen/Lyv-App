//
//  BeaconController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class BeaconController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    
    var beacon: Beacon?
    
    @IBAction func imageButtonPressed(_ sender: Any) {
    }
    
    @IBAction func launchButtonPressed(_ sender: Any) {
        createBeacon()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func createBeacon() {
        if nameTextField.text == "" {
            showAlert(withMessage: "Please add a title for your beacon")
        } else {
            
            //figure out how to store image data
            beacon = Beacon(title: nameTextField.text!, date: Date(), distance: distanceSlider.hashValue, description: descriptionTextField.text ?? "", imageURL: "")
            
            BeaconService.create(forBeacon: beacon)
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
