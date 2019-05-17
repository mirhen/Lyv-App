//
//  ViewController+Utility.swift
//  Cardinal Connect
//
//  Created by Miriam Haart on 4/15/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(withMessage message: String, title: String? = "") {
        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    func toDayAndHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE 'at' hh mm a"
        return formatter.string(from: self)
    }
}

extension UIButton {
    func addBorder(_ radius: CGFloat = 6, color: UIColor = .black) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
}

struct StanfordColors {
    static let darkred = UIColor.init(red: 177/255, green: 6/255, blue: 14/255, alpha: 1)
    static let beige = UIColor.init(red: 179/255, green: 153/255, blue: 93/255, alpha: 1)
}

struct Helper {
    static func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}
