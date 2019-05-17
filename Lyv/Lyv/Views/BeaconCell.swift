//
//  BeaconCell.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class BeaconCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var beaconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Variables
    var beacon: Beacon? {
        didSet {
            setUpUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        beaconImageView.layer.cornerRadius = beaconImageView.frame.size.width / 2
        beaconImageView.clipsToBounds = true
    }
    
    func setUpUI() {
        
        if let beacon = beacon {
            
    
            titleLabel.text = beacon.title
            descriptionLabel.text = beacon.description
//            let imageURL = URL(string: user.profileURL)
//            self.profileImageView.kf.setImage(with: imageURL)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
