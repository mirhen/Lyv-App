//
//  Hangout.swift
//  Cardinal Connect
//
//  Created by Miriam Haart on 4/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot
import CoreLocation
import SceneKit
import ARCL
import CoreLocation

class Beacon {
    
    
    var title: String = ""
    var date: Date
    var distance: Int = 5
    var description: String = ""
    var imageURL: String = ""
    var uid: String
    var key: String?
    var latitude: Float
    var longitude: Float
    
    var dictValue: [String : Any] {
        let date = self.date.timeIntervalSince1970
        return ["date" : date,
                "title" : title,
                "distance" : distance,
                "description": description,
                "latitude": latitude,
                "longitude": longitude,
                "imageURL": imageURL]
    }
    
    init(title: String, uid: String, date: Date, distance: Int, description: String, imageURL: String, latitude: Float, longitude: Float) {
        self.date = date
        self.title = title
        self.uid = uid
        self.distance = distance
        self.description = description
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict["title"] as? String,
            let date = dict["date"] as? TimeInterval,
            let uid = dict["uid"] as? String,
            let distance = dict["distance"] as? Int,
            let description = dict["description"] as? String,
            let imageURL = dict["imageURL"] as? String,
            let latitude = dict["latitide"] as? Float,
            let longitude = dict["longitude"] as? Float
            
            else { return nil }
        
        
        self.uid = uid
        self.key = snapshot.key
        self.title = title
        self.date = Date(timeIntervalSince1970: date)
        self.distance = distance
        self.description = description
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func creatAnnotationNode() -> LocationAnnotationNode{
        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude)), altitude: 0)
        let image = UIImage(named: "LocationPin")!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.annotationNode.name = self.title
        
        return annotationNode

    }
}
