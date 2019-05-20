//
//  ProfileController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var beacons = [Beacon]()
    var selectedBeacon: Beacon?
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let initialViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserService.getBeacons(for: User.current) { (beacons) in
            self.beacons = beacons
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toBeacon {
            if let destination = segue.destination as? BeaconController {
                if let beacon = selectedBeacon {
                    destination.beacon = beacon
                }
            }
        }
    }
    
    func setupUI() {
        self.usernameLabel.text = User.current.username
        
//        let imageURL = URL(string: User.current.profileURL)
//        self.profileImageView.kf.setImage(with: imageURL)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }


    
}

// MARK: - UITableViewDataSource

extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconCell") as! BeaconCell
        
        cell.setUpUI()
        
        return cell
    }

}

