//
//  CreateExerciseTableViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/17/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase

class CreateExerciseTableViewController: UITableViewController {
        let db = Firestore.firestore()
        let muscleGroups = ["Shoulders", "Biceps",
        "Abs","Tighs", "Calves", "Back", "Chest"]
        var date : String = ""
    //    var workoutManager = WorkoutManager()
        var muscleGroupChosen: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muscleGroup.dataSource = self as UIPickerViewDataSource
        muscleGroup.delegate = self as UIPickerViewDelegate
        date = WorkoutManager.shared.date
    }

       @IBAction func addExercise(_ sender: UIButton) {
            let muscleGroupChosen = muscleGroups[muscleGroup.selectedRow(inComponent: 0)]
            if let exercise = exerciseField.text, let repetitions = repetitionsField.text, let sets =  setsField.text, let user = Auth.auth().currentUser {
                let workoutData : [String: Any] = [
                            exercise: [
                                "name": exercise,
                                "repetitions": repetitions,
                                "muscle_group": muscleGroupChosen,
                                "date": Date().timeIntervalSince1970,
                                "sets": sets
                            ]
                ]
                db.collection("users").document(user.email!).collection("Scheduled workouts").document(date).setData(workoutData, merge: true)
                
                
        }
            let destinationVC = storyboard?.instantiateViewController(identifier: "calendar") as! CalendarViewController
            
            destinationVC.displayExercises(date: date)
            self.dismiss(animated: true, completion: nil)
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension CreateExerciseTableViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muscleGroups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        muscleGroupChosen = muscleGroups[row]
    }
}
