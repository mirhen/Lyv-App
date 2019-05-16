//
//  HangoutService.swift
//  Cardinal Connect
//
//  Created by Miriam Haart on 4/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct HangoutService {
    
    static func create(forBeacon beacon: Beacon, fromUser: User) {
        // 3
        let dict = beacon.dictValue
        // 4
        let entryKey = Helper.randomAlphaNumericString(length: 28)
        let entryRef = Database.database().reference().child("beacons").child(fromUser.uid).child(entryKey)
      
        //5
        entryRef.setValue(dict)
    }
    
    
    static func updateBeacon(forBeacon beacon: Beacon) {
        
        let entryRef = Database.database().reference().child("beacons").child(User.current.uid).child(beacon.key!)
        let dict = beacon.dictValue
        
        entryRef.setValue(dict)
    }
}

