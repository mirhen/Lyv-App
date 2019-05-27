//
//  LandingController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/21/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class LandingController: UIViewController {

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#DD54DF")
    private let subtitleColor = UIColor(hexString: "#464646")
    private let signUpButtonColor = UIColor(hexString: "#414665")
    private let signUpButtonBorderColor = UIColor(hexString: "#B0B3C6")
    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let subtitleFont = UIFont.boldSystemFont(ofSize: 18)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 24)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = UIImage.localImage("logo", template: true)
        logoImageView.tintColor = tintColor
        
        titleLabel.font = titleFont
        titleLabel.text = "Welcome to Lyv"
        titleLabel.textColor = tintColor
        
        subtitleLabel.font = subtitleFont
        subtitleLabel.text = "Connecting you to the world"
        subtitleLabel.textColor = subtitleColor
        
        loginButton.setTitle("Log in", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: .white,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: signUpButtonColor,
                               font: buttonFont,
                               cornerRadius: 55/2,
                               borderColor: signUpButtonBorderColor,
                               backgroundColor: backgroundColor,
                               borderWidth: 1)
        
        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "OR"
        
        facebookButton.setTitle("Facebook Login", for: .normal)
        facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        facebookButton.configure(color: backgroundColor,
                                 font: buttonFont,
                                 cornerRadius: 55/2,
                                 backgroundColor: UIColor(hexString: "#334D92"))
        

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func didTapLoginButton() {
//        let loginVC = LoginController()
//        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func didTapSignUpButton() {
//        let signUpVC = SignUpController()
//        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func didTapFacebookButton() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                guard let user = user else {
                    return
                }
                UserService.show(forUID: user.user.uid) { (userObject) in
                    if let userObject = userObject {
                        // handle existing user
                        User.setCurrent(userObject, writeToUserDefaults: true)
                        
                        let initialViewController = UIStoryboard.initialViewController(for: .main)
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    } else {
                        //create user
                        UserService.create(user.user, username: user.user.displayName ?? "Name") { (user) in
                            guard let user = user else {
                                return
                            }
                            User.setCurrent(user, writeToUserDefaults: true)
                            //                    self.performSegue(withIdentifier: Constants.Segue.toWelcomeUser , sender: self)
                            let initialViewController = UIStoryboard.initialViewController(for: .main)
                            self.view.window?.rootViewController = initialViewController
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
            })
            
        }
    }
    
    @IBAction func exitToLanding(segue: UIStoryboardSegue) { }
    
    
}
