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
    @IBOutlet weak var beaconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //Variables
    var beacon: Beacon? {
        didSet {
            setUpUI()
        }
    }
    
    override func awakeFromNib() {
        beaconImageView.layer.cornerRadius = beaconImageView.frame.size.width / 2
        beaconImageView.clipsToBounds = true
    }
    
    func setUpUI() {
        
        if let beacon = beacon {
            titleLabel.text = beacon.title
            beaconImageView.image = UIImage(data: beacon.imageData)
        }
        
    }
    
}
