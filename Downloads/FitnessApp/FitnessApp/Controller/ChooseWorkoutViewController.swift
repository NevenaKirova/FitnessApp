//
//  ChooseWorkoutViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/24/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase
import MIBlurPopup

//protocol AddCustomWorkoutDelegate {
//    func addWorkout(exercises: [Exercise])
//}

class ChooseWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MIBlurPopupDelegate {
    
    var workoutChosen : String = ""
    
    var date : String = WorkoutManager.shared.date
    
    var popupView: UIView = UIView()
    
    var blurEffectStyle: UIBlurEffect.Style = .dark
    
    
    var initialScaleAmmount: CGFloat = 0.5
    
    var animationDuration: TimeInterval = 0.5
    

    var workouts : [String] = []
    var exercises : [Exercise] = []
    
    var addExerciseDelegate : AddNewExerciseDelegate?
    
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getCustomWorkouts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
        print("TODAY: \(date)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func getCustomWorkouts() {
        db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.customWorkouts).addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents {
                    self.workouts.append(doc.documentID)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = workouts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exercises.removeAll()
        
        let chosenWorkout = workouts[indexPath.row]
        getExercisesForChosenWorkout(workout: chosenWorkout)
        
        
    }
    
    func getExercisesForChosenWorkout(workout: String) {
        db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.customWorkouts  ).addSnapshotListener { (snapshot, error) in
            
            
                if let e = error {
                    print(e)
                    return
                }
                else {
                    for doc in snapshot!.documents {
                        if doc.documentID == workout && doc.exists{
                            for data in doc.data() as! [String: [String: Any]] {
                                if let reps = data.value[Constants.DocumentFields.repetitions] as? String, let sets = data.value[Constants.DocumentFields.sets] as? String, let timeOfCreation = data.value["date"] as? Double, let muscleGroup = data.value[Constants.DocumentFields.muscleGroup] as? String {
                                
                                    let newExercise = Exercise(exerciseName: data.key, repetitions: reps, muscleGroup: muscleGroup, timeOfCreation: timeOfCreation, sets: sets)
                                self.exercises.append(newExercise)
                                print(newExercise.exerciseName)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func writeExerciseInDatabase() {
        for exercise in exercises {
            let data = [
                exercise.exerciseName: [
                    Constants.DocumentFields.muscleGroup: exercise.muscleGroup,
                    Constants.DocumentFields.exerciseName: exercise.exerciseName,
                    Constants.DocumentFields.repetitions: exercise.repetitions,
                    Constants.DocumentFields.sets: exercise.sets,
                    Constants.DocumentFields.timeOfCreation: exercise.timeOfCreation,
                ]
            ]; db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.schedueledWorkouts).document(date).setData(data, merge: true)
        }
    }
    
    @IBAction func addWorkout(_ sender: UIButton) {
        
        writeExerciseInDatabase()
        
//        addExerciseDelegate!.addExercice(date: WorkoutManager.shared.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}



