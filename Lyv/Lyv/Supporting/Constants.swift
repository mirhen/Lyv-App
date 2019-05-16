//
//  Constants.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        static let toWelcomeUser = "toWelcomeUser"
        static let toJournalEntries = "toJournalEntries"
        static let toCreateBeacon = "toCreateBeacon"
    }
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
        static let beacons = "beacons"
        static let profileURL = "profileURL"
    }
}
