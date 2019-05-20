//
//  LoginViewController.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseUI
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

typealias FIRUser = FirebaseAuth.User

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Set background Image
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = #imageLiteral(resourceName: "background")
//        self.view.insertSubview(backgroundImage, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    
    @IBAction func facebookLogin(sender: UIButton) {
        
//
//        let permissions: [Permission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
//
//        let fbLoginManager = LoginManager()
//
//        fbLoginManager.logIn(permissions: permissions, viewController: self, completion: didReceiveFacebookLoginResult)
//
//
//        guard let accessToken = AccessToken.current else {
//                print("Failed to get access token")
//                return
//            }
//
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//
        
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
//
//    func didReceiveFacebookLoginResult(loginResult: LoginResult) {
//        switch loginResult {
//        case .success:
//            didLoginWithFacebook()
//        case .failed(_): break
//        default: break
//        }
//    }
    
//    func didLoginWithFacebook() {
//        // Successful log in with Facebook
//        if let accessToken = AccessToken.current {
//            // If Firebase enabled, we log the user into Firebase
//
//            FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)) {[weak self] (success) in
//                guard let `self` = self else { return }
//                var message: String = ""
//                if (success) {
//                    message = "User was sucessfully logged in."
//                } else {
//                    message = "There was an error."
//                }
//                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                self.display(alertController: alertController)
//            }
//        }
//    }
}



extension LoginController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if error != nil {
            //            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else {
            return
        }
        UserService.show(forUID: user.uid) { (userObject) in
            if let userObject = userObject {
                // handle existing user
                User.setCurrent(userObject, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            } else {
                //create user
                UserService.create(user, username: user.displayName ?? "Name") { (user) in
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
    }
}
