//
//  DetailsController.swift
//  Lyv
//
//  Created by Miriam Haart on 6/6/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    
    var beacon: Beacon?
    
    @IBAction func checkInButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        if let beacon = beacon {
            imageView.image = UIImage(data: beacon.imageData)!
            titleLabel.text! = beacon.title
            descriptionTextView.text! = beacon.description
            distanceLabel.text = "\(beacon.getDistance())m"
        
        }
        
        descriptionTextView.addBorder()
        descriptionTextView.layer.cornerRadius = 10
        
        checkInButton.configure(color: .white,
                                  font: UIFont.systemFont(ofSize: 20),
                                  cornerRadius: 55/2,
                                  backgroundColor: LyvColors.darkpurple)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        print(location)
    }
}
