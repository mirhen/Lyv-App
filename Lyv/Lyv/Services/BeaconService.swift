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

struct BeaconService {
    
    static func create(forBeacon beacon: Beacon) {
        // 3
        let dict = beacon.dictValue
        // 4
        let entryKey = Helper.randomAlphaNumericString(length: 28)
        let entryRef = Database.database().reference().child("beacons").child(entryKey)
        //5
        entryRef.setValue(dict)
        print(dict)
    }
    
    
    static func updateBeacon(forBeacon beacon: Beacon) {
        
        let entryRef = Database.database().reference().child("beacons").child(beacon.key!)
        let dict = beacon.dictValue
        
        entryRef.setValue(dict)
    }
    
    static func beacons(completion: @escaping ([Beacon]) -> Void) {
        let ref = Database.database().reference().child("beacons")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let beacons = snapshot.reversed().compactMap(Beacon.init)
            
            print(beacons.map {$0.title} )
            
            completion(beacons)
        })
    }
    
    
}

