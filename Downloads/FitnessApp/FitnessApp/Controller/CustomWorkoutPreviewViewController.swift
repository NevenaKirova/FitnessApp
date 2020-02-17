//
//  CustomWorkoutViewController.swift
//  
//
//  Created by Mitko on 1/15/20.
//

import UIKit
import Firebase

class CustomWorkoutPreviewViewController: UIViewController {
    var exercises : [Exercise] = []
    var workout = ""
    let db = Firestore.firestore()
    @IBOutlet weak var workoutTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func getExercisesForCustomWorkout() {
        if let user = Auth.auth().currentUser?.email {
            db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.customWorkouts).addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    for doc in snapshot!.documents {
                        if doc.documentID == self.workout {
                            for data in doc.data() as! [String: [String: Any]] {
                                if let repetitions = data.value["repetitions"] as? String, let sets = data.value["sets"] as? String, let muscleGroup = data.value["muscle_group"] as? String, let timeOfCreation = data.value["timeOfCreation"] as? Double {
                                    let newExercise = Exercise(exerciseName: data.key, repetitions: repetitions, muscleGroup: muscleGroup, timeOfCreation: timeOfCreation, sets: sets)
                                    self.exercises.append(newExercise)
                            }
                        }
                    }
                }
            }
        }
            
    }
}
}



extension CustomWorkoutPreviewViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exercises[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewExercise") as! CustomWorkoutExercisesTableViewCell
        return cell
    }
}
