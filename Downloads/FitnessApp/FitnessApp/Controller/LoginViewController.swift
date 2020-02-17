//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: TextFieldFloatingPlaceholder!
    @IBOutlet var passwordTextField: TextFieldFloatingPlaceholder!
    
    @IBOutlet var errorLabel: UILabel!
    let userDefaults = UserDefaults.standard
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
//        emailTextField.text = Constants.Profile.email
//        passwordTextField.text = Constants.Profile.password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userDefaults.string(forKey: Constants.UserDef.email) != nil {
            if let email = userDefaults.string(forKey: Constants.UserDef.email),
                let password = userDefaults.string(forKey: Constants.UserDef.password) {
            print(email)
                print(password)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let destinationVC = self.storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.tabController) as! UITabBarController
                    self.navigationController?.setViewControllers([destinationVC], animated: true)
                }
            }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    self.userDefaults.setValue(email, forKey: Constants.UserDef.email)
                    self.userDefaults.setValue(password, forKey: Constants.UserDef.password)
                    let destinationVC = self.storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.tabController) as! UITabBarController
                    self.navigationController?.setViewControllers([destinationVC], animated: true)
            }
        }
            
        }
    }
        
    func updateTextFields() {
        emailTextField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        emailTextField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255, alpha: 1)
        passwordTextField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        passwordTextField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255/255, alpha: 1)
    }
}

