//
//  ProfileController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/16/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var pescribedButton: UIButton!
    @IBOutlet weak var wellnessButton: UIButton!
    @IBOutlet weak var wellnessView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var beacons = [Beacon]()
    var selectedBeacon: Beacon?
    var pescribedData = [
        ["image" : "exercise", "descript": "4 Exercise Activites"],
        ["image" : "healthy", "descript": "3 Healthy Meals"],
        ["image" : "social", "descript": "1 Social Outing"],
        ["image" : "journal", "descript": "7 Journal Entries"]
    ]
    
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
    @IBAction func exitToProfile(segue: UIStoryboardSegue) { }
    @IBAction func currentPressed(_ sender: Any) {
        pescribedButton.setTitleColor(.lightGray, for: .normal)
        wellnessButton.setTitleColor(.lightGray, for: .normal)
        currentButton.setTitleColor(.black, for: .normal)
        wellnessView.isHidden = true
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    @IBAction func pescribedPressed(_ sender: Any) {
        currentButton.setTitleColor(.lightGray, for: .normal)
        wellnessButton.setTitleColor(.lightGray, for: .normal)
        pescribedButton.setTitleColor(.black, for: .normal)
        wellnessView.isHidden = false
        tableView.isHidden = false
        collectionView.isHidden = true
    }
    @IBAction func wellnessPressed(_ sender: Any) {
        pescribedButton.setTitleColor(.lightGray, for: .normal)
        currentButton.setTitleColor(.lightGray, for: .normal)
        wellnessButton.setTitleColor(.black, for: .normal)
        wellnessView.isHidden = false
        tableView.isHidden = true
        collectionView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if beacons.count == 0 {
        UserService.getBeacons(for: User.current) { (beacons) in
            self.beacons = beacons
            
            self.collectionView.reloadData()
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toUpdate {
            if let destination = segue.destination as? UpdateController {
                if let beacon = selectedBeacon {
                    destination.beacon = beacon
                }
            }
        }
    }
    
    func setupUI() {
        
        
        self.usernameLabel.text = User.current.username
        
        if User.current.profileURL != "?width=300&height=300" {
            let imageURL = URL(string: User.current.profileURL)
            self.profileImageView.kf.setImage(with: imageURL)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        pescribedButton.setTitleColor(.lightGray, for: .normal)
        wellnessButton.setTitleColor(.lightGray, for: .normal)
        wellnessView.isHidden = true
        tableView.isHidden = true
    }

}

extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beacons.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3
        let height = collectionView.frame.height/3
        
        return CGSize(width: width - 20, height: height - 5)

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeaconCell", for: indexPath) as! BeaconCell
        
        let beacon = beacons[indexPath.item]
        cell.beacon = beacon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let beacon = beacons[indexPath.row]
        selectedBeacon = beacon
        self.performSegue(withIdentifier: Constants.Segue.toUpdate, sender: self)
    }
    
}


extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pescribedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PescribeCell", for: indexPath) as! PescribeCell
        
        let cellData = pescribedData[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: cellData["image"]!)
        cell.descriptLabel.text! = cellData["descript"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
}
