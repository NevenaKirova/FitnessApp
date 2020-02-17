//
//  CreateWorkoutViewController.swift
//  FitnessApp
//
//  Created by Mitko on 12/22/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
import Firebase

class CreateExerciseViewController: UIViewController{
    let db = Firestore.firestore()
    let muscleGroups = ["Shoulders", "Biceps",
    "Abs","Tighs", "Calves", "Back", "Chest"]
    var date : String = ""
//    var workoutManager = WorkoutManager()
    var muscleGroupChosen: String = ""
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var repetitionsField: UITextField!
    @IBOutlet weak var muscleGroup: UIPickerView!
    @IBOutlet weak var setsField: UITextField!
    
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


extension CreateExerciseViewController : UIPickerViewDataSource, UIPickerViewDelegate {
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
    
    

   



