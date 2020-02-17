//
//  YourWorkoutsViewController.swift
//  FitnessApp
//
//  Created by Mitko on 1/11/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit
import Firebase

class YourWorkoutsViewController: UIViewController {
    var workouts : [String] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getWorkouts()
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print("WORKOUTS: \(WorkoutManager.shared.workouts.count)")
        }
        
    }
    
    
    @IBAction func createRoutine(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.createRoutine) as! CreateWorkoutViewController
        destinationVC.addWorkoutRoutineDelegate = self
        WorkoutManager.shared.workouts.removeAll()
        present(destinationVC, animated: true, completion: nil)
    }
    
    func getWorkouts() {
        if let user = Auth.auth().currentUser?.email
        {
            let workoutRef = db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.customWorkouts)
        workoutRef.addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e)
            } else {
                for doc in snapshot!.documents {
                    WorkoutManager.shared.workouts.append(doc.documentID)
                    print(doc.documentID)
                    print(WorkoutManager.shared.workouts.count)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        WorkoutManager.shared.numberOfWorkouts += 1
                    }
                }
            }
        }
     }
        workouts = WorkoutManager.shared.workouts
    }
    
}


extension YourWorkoutsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutManager.shared.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.routine) as! WorkoutRoutineTableViewCell
        cell.routineTitle.text = WorkoutManager.shared.workouts[indexPath.row]
        cell.background.layer.cornerRadius = 6
        cell.background.layer.shadowColor = UIColor.black.cgColor
        cell.background.layer.shadowOpacity = 0.4
        cell.background.layer.shadowRadius = 6
        cell.background.layer.shadowOffset = CGSize(width: 2, height: 3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutChosen = workouts[indexPath.row]
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.workoutPreview) as! CustomWorkoutPreviewViewController
        destinationVC.workout = workoutChosen
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: Constants.SwipeAction.delete) { (action, view, nil) in
            if let user = Auth.auth().currentUser?.email, let workoutToBeDeleted = WorkoutManager.shared.workouts[indexPath.row] as? String{
            self.db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.customWorkouts).document(workoutToBeDeleted).delete()
                
                WorkoutManager.shared.numberOfWorkouts -= 1
                WorkoutManager.shared.workouts.removeAll { (workout) -> Bool in
                    return workout == workoutToBeDeleted
                }
                    tableView.deleteRows(at: [indexPath], with: .bottom)
                }
            }
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

extension YourWorkoutsViewController: addWorkoutRoutineDelegate {
    func addWorkout() {
        print("add workout delegate")
        WorkoutManager.shared.workouts.removeAll()
        self.getWorkouts()
        WorkoutManager.shared.numberOfWorkouts += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            self.tableView.reloadData()
        }
    }
}
