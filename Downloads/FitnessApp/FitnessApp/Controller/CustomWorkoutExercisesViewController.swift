//
//  CustomWorkoutExercisesViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/15/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
class CustomWorkoutPreview: UIViewController {
    @IBOutlet weak var workoutDayTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let exercises : [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getExercisesForWorkout()
    }
    
    func getExercisesForWorkout() {
        if let user = Auth.auth().currentUser?.email {
            db.collection("users").document(user).collection("Schedueled workouts").addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    
                }
            }
        }
    }

}


extension CustomWorkoutPreview : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
}
