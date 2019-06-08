//
//  BeaconCell.swift
//  Lyv
//
//  Created by Miriam Haart on 5/22/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class BeaconCell: UICollectionViewCell {
    
    //IBOutlets
    @IBOutlet weak var beaconView: BeaconView!
    
    //Variables
    var beacon: Beacon? {
        didSet {
            setUpUI()
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    func setUpUI() {
        
        if let beacon = beacon {
            beaconView.imageView.image = UIImage(data: beacon.imageData)
            beaconView.imageView.maskCircle()
            beaconView.frameImageView.isHidden = true
            beaconView.longFrameImageView.isHidden = true
            beaconView.titleLable.text = beacon.title
        }
        
    }
    
}
