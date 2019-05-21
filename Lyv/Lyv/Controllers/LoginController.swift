//
//  LoginController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/21/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseUI
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

class LoginController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var contactPointTextField: ATCTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#ff5a66")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.font = titleFont
        titleLabel.text = "Log In"
        titleLabel.textColor = tintColor
        
        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true
        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true
        
        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "OR"
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        
        facebookButton.setTitle("Facebook Login", for: .normal)
        facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        facebookButton.configure(color: backgroundColor,
                                 font: buttonFont,
                                 cornerRadius: 55/2,
                                 backgroundColor: UIColor(hexString: "#334D92"))
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapLoginButton() {
        
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                print("Login Error")
            } else {
                if let user = result?.user {
                UserService.show(forUID: user.uid) { (userObject) in
                    if let userObject = userObject {
                        // handle existing user
                        User.setCurrent(userObject, writeToUserDefaults: true)
                        
                        let initialViewController = UIStoryboard.initialViewController(for: .main)
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    } else {
                        self.showAlert(withMessage: "Login Failed")
                    }
                }
            }
        }
    }
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
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

