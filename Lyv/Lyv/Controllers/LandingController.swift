//
//  LandingController.swift
//  Lyv
//
//  Created by Miriam Haart on 5/21/19.
//  Copyright © 2019 Miriam Haart. All rights reserved.
//

import UIKit

class LandingController: UIViewController {

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let subtitleColor = UIColor(hexString: "#464646")
    private let signUpButtonColor = UIColor(hexString: "#414665")
    private let signUpButtonBorderColor = UIColor(hexString: "#B0B3C6")
    
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
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: signUpButtonColor,
                               font: buttonFont,
                               cornerRadius: 55/2,
                               borderColor: signUpButtonBorderColor,
                               backgroundColor: backgroundColor,
                               borderWidth: 1)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)

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
    
    @IBAction func exitToLanding(segue: UIStoryboardSegue) { }
}
