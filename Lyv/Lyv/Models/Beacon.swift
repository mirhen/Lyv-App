//
//  Hangout.swift
//  Cardinal Connect
//
//  Created by Miriam Haart on 4/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Beacon {
    
    
    var title: String = ""
    var date: Date
    var distance: Int = 5
    var description: String = ""
    var imageURL: String = ""
    var key: String?
    
    var dictValue: [String : Any] {
        let date = self.date.timeIntervalSince1970
        return ["date" : date,
                "title" : title,
                "distance" : distance,
                "description": description,
                "imageURL": imageURL]
    }
    
    init(title: String, date: Date, distance: Int, description: String, imageURL: String) {
        self.date = date
        self.title = title
        self.distance = distance
        self.description = description
        self.imageURL = imageURL
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict["title"] as? String,
            let date = dict["date"] as? TimeInterval,
            let distance = dict["distance"] as? Int,
            let description = dict["description"] as? String,
            let imageURL = dict["imageURL"] as? String
            else { return nil }
        

        self.key = snapshot.key
        
        self.title = title
        self.date = Date(timeIntervalSince1970: date)
        self.distance = distance
        self.description = description
        self.imageURL = imageURL
        
    }
}
