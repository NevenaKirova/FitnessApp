//
//  IntroductionViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/13/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase
import TextFieldFloatingPlaceholder



class IntroductionViewController: UIViewController{
    @IBOutlet var usernameTextField: TextFieldFloatingPlaceholder!
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.validationTrueLineColor = UIColor.black.withAlphaComponent(1)
        usernameTextField.validationTrueLineEditingColor = UIColor.init(red: 203/255, green: 209/255, blue: 255, alpha: 1)
    }
    
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        setUsername();
    }
    func setUsername() {
        
        if let user = Auth.auth().currentUser, let username = usernameTextField.text {
            db.collection(Constants.CollectionNames.users).document(user.email!).setData([
                Constants.DocumentFields.username: username
                ], merge: true)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
