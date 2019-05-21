//
//  UserService.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        var profileURL = firUser.photoURL?.absoluteString ?? ""
        profileURL += "?width=300&height=300"
        
        let userAttrs = ["username": username, "profileURL": profileURL]
    
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func updateUserValues(_ user: User) {
        let userAttrs = user.dictValue
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            User.setCurrent(user, writeToUserDefaults: true)
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func users(for user: User, completion: @escaping ([User]) -> Void) {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            var users = snapshot.reversed().compactMap(User.init)
            users = users.filter {$0.uid != User.current.uid}
            
            completion(users)
        })
    }
    
    static func getBeacons(for user: User, completion: @escaping ([Beacon]) -> Void) {
        let ref = Database.database().reference().child("beacons")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let beacons = snapshot.reversed().compactMap(Beacon.init).filter {$0.uid == user.uid }

            User.current.beacons = beacons.map{ $0.key! }
            print(beacons.count)
            completion(beacons)
        })
    }
    
}
