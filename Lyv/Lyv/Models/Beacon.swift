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
    var imageData: Data = UIImage(named: "user")!.jpegData(compressionQuality: 0.5)!
    var uid: String
    var key: String?
    var latitude: Float
    var longitude: Float
    
    var dictValue: [String : Any] {
        let date = self.date.timeIntervalSince1970
        return ["date" : date,
                "title" : title,
                "uid": uid,
                "distance" : distance,
                "description": description,
                "latitude": latitude,
                "longitude": longitude,
                "imageData": imageData.base64EncodedString()]
    }
    
    init(title: String, uid: String, date: Date, distance: Int, description: String, imageData: Data, latitude: Float, longitude: Float) {
        self.date = date
        self.title = title
        self.uid = uid
        self.distance = distance
        self.description = description
        self.imageData = imageData
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
            let imageData = dict["imageData"] as? String,
            let latitude = dict["latitude"] as? Float,
            let longitude = dict["longitude"] as? Float
            
            else { return nil }
        
        
        self.uid = uid
        self.key = snapshot.key
        self.title = title
        self.date = Date(timeIntervalSince1970: date)
        self.distance = distance
        self.description = description
        self.imageData = Data(base64Encoded: imageData) ?? UIImage(named: "LocationPin")!.jpegData(compressionQuality: 0.5)!
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func creatAnnotationNode(withLine: Bool = false, currentLocation: CLLocation) -> LocationAnnotationNode {
        
        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude)), altitude: 15)
        print(self.title, location)
        let image = UIImage(data: self.imageData)!//UIImage(data: self.imageData)!
        
        let distance = currentLocation.distance(from: CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))) / 1609.344
        
        let size = setSizeFrom(CGFloat(distance))
        print(title, size)
        let frame = CGRect(origin: CGPoint.init(), size: CGSize(width: 125, height: 300))// setViewFrame(distance: CGFloat(distance))
//        print(self.title, frame)
        //Instantiate Beacon View
        let view = BeaconView(frame: frame)
        view.imageView.image = image
        view.imageView.layer.cornerRadius = view.imageView.frame.height/2
        view.titleLable.text = self.title
        view.backgroundColor = .clear
        view.isOpaque = false
        
        if !withLine {
            view.longFrameImageView.isHidden = true
        }
        
        let annotationNode = LocationAnnotationNode(location: location, image: view.asImage().resizeImage(targetSize: size))
        annotationNode.annotationNode.name = self.title
        
        return annotationNode

    }
    

    //Helper Functions
    
    func setSizeFrom(_ distance: CGFloat) -> CGSize {
        
        let maxDistance: CGFloat = 1
        
        let maxSize = CGSize(width: 125, height: 300)
        let minSize = CGSize(width: 31.25, height: 75)
        
        
        let distancePercentage = (distance / maxDistance)
        let widthPerc = (maxSize.width - minSize.width)
        let heightPerc = (maxSize.height - minSize.height)
        
        let width = distancePercentage * widthPerc
        let height = distancePercentage *  heightPerc
        
        var size = CGSize(width:  maxSize.width - width, height: maxSize.height - height)
        
        if size.height > maxSize.height {
            size = maxSize
        } else if size.height < minSize.height {
            size = minSize
        }
        
        
        return size
    }
    
    func getDistance() -> Double {
        
        let distance = currentLocation.distance(from: CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))) / 1609.344
        let rounded = Double(String(format:"%.2f", distance))!
        
        return rounded
    }


    
    
}
