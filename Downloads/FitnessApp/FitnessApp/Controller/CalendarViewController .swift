import UIKit
import Firebase
import FSCalendar
import IQKeyboardManagerSwift


class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    
    var currentDate = ""
    let user = Auth.auth().currentUser?.email
    
    
    
    let db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    fileprivate weak var calendar : FSCalendar!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateCalendar()
        tableView.delegate = self
        tableView.dataSource = self
        calendar.scope = .month
        let formattedDate = self.dateFormater.string(from: Date())
        navigationController?.setNavigationBarHidden(true, animated: true)
        currentDate = formattedDate
        WorkoutManager.shared.date = formattedDate
        print(formattedDate)
        displayExercises(date: currentDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("View did appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        WorkoutManager.shared.exercises.removeAll()
    }
    
    fileprivate var dateFormater : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormatter.format
        return formatter
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formattedDate = self.dateFormater.string(from: date)
        currentDate = formattedDate
        displayExercises(date: formattedDate)
        WorkoutManager.shared.date = currentDate
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var numberOfEvents = 0
        let currentUser = Auth.auth().currentUser?.email
        let formattedDate = self.dateFormater.string(from: date)
        let scheduledWorkoutDocument = db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.schedueledWorkouts).document(formattedDate)
        scheduledWorkoutDocument.getDocument { (document, error) in
            if let doc = document, doc.exists {
                print("yeah")
                numberOfEvents = 1
            }
        }
        
        return numberOfEvents
    }
    
    func displayExercises(date: String) {
        WorkoutManager.shared.exercises.removeAll()
        print("did select date: \(date)")
        getExercises(date: date)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            WorkoutManager.shared.numberOfExercises = WorkoutManager.shared.exercises.count
            print(WorkoutManager.shared.numberOfExercises)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addExercise(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.createExercise) as! CreateExerciseTableViewController
        
        destinationVC.addExerciseDelegate = self
        present(destinationVC, animated: true, completion: nil)
        WorkoutManager.shared.date = currentDate
        destinationVC.date = WorkoutManager.shared.date
        print("current date: \(currentDate)")
        print("vc date \(destinationVC.date)")
    }
    
    func getExercises(date: String) {
        
        
        WorkoutManager.shared.exercises.removeAll()
        let exerciseReference = db.collection(Constants.CollectionNames.users).document(user!).collection(Constants.CollectionNames.schedueledWorkouts)
        
        
        exerciseReference.addSnapshotListener { (snapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            } else {
                if snapshot == nil || snapshot?.documents.isEmpty == true{
                    return
                }
                    else {
                    for doc in snapshot!.documents {
                            if doc.documentID == date && doc.exists{
                                var newExercise : Exercise
                                for data in doc.data() as! [String: [String:Any]]{
                                    if let repetitions = data.value[Constants.DocumentFields.repetitions] as? String, let muscleGroup = data.value[Constants.DocumentFields.muscleGroup] as? String, let sets = data.value[Constants.DocumentFields.sets] as? String, let timeOfCreation = data.value[Constants.DocumentFields.timeOfCreation] as? Double {
                                        newExercise = Exercise(exerciseName: data.key, repetitions: repetitions, muscleGroup: muscleGroup, timeOfCreation: timeOfCreation, sets: sets)
                                            print("new Exercise: \(newExercise.exerciseName), repetitions: \(newExercise.repetitions), muscle group: \(newExercise.muscleGroup)")
                                            WorkoutManager.shared.exercises.append(newExercise)
                                                }
                                            }
                                        }
                                    }
                    WorkoutManager.shared.exercises.sort { (ex1: Exercise, ex2: Exercise) -> Bool in
                        ex1.timeOfCreation < ex2.timeOfCreation
                    }
                            }
                        }
                    }
            }

    @IBAction func choseWorkout(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(identifier: Constants.ControllersIdentifiers.chooseWorkout) as! ChooseWorkoutViewController
        destinationVC.addExerciseDelegate = self
        destinationVC.date = currentDate
        
    }
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return WorkoutManager.shared.numberOfExercises
        }
    
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let exercise = WorkoutManager.shared.exercises[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.exercise, for: indexPath) as! CalendarExerciseTableViewCell
            
            cell.exerciseName.text = exercise.exerciseName
            cell.repsLabel.text = "\(exercise.repetitions) reps"
            cell.setsLabel.text = "\(exercise.sets) sets"
            switch exercise.muscleGroup {
            case "Shoulders":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "shoulderEdited")
            case "Biceps":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "bicepsEdited")
            case "Abs":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "abs")
            case "Tighs":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "tighs")
            case "Calves":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "calves")
            case "Back":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "backEdited")
            case "Chest":
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "chestEdited")
            default:
                cell.muscleGroupImage.image = #imageLiteral(resourceName: "dumbbell")
            }
            
            cell.background.layer.cornerRadius = 6
            cell.background.layer.shadowColor = UIColor.black.cgColor
            cell.background.layer.shadowOpacity = 0.4
            cell.background.layer.shadowRadius = 6
            cell.background.layer.shadowOffset = CGSize(width: 2, height: 3)

            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            
        let done = UIContextualAction(style: .normal, title: Constants.SwipeAction.done) { (action, view, nil) in
            
        }
        done.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: Constants.SwipeAction.delete) { (action, view, nil) in
            if let user = self.user, let exerciseToBeDeleted = WorkoutManager.shared.exercises[indexPath.row].exerciseName as? String{
                self.db.collection(Constants.CollectionNames.users).document(user).collection(Constants.CollectionNames.schedueledWorkouts).document(self.currentDate).updateData([
                        exerciseToBeDeleted: FieldValue.delete()
                    ])
                
                WorkoutManager.shared.numberOfExercises -= 1
                WorkoutManager.shared.exercises.removeAll { (exercise) -> Bool in
                    return exercise.exerciseName == exerciseToBeDeleted
                }
                    tableView.deleteRows(at: [indexPath], with: .bottom)
                }
            
            }
        
        
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
     
    func noExercisesView() {
        if WorkoutManager.shared.numberOfExercises == 0 {
            
        }
    }
    
    
    func generateCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 50, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.accessibilityIdentifier = "calendar"
        view.addSubview(calendar)
        
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        self.calendar = calendar
    }
}

extension CalendarViewController: AddNewExerciseDelegate {
    func addExercice(date: String) {
        tableView.reloadData()
//        WorkoutManager.shared.exercises.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.displayExercises(date: WorkoutManager.shared.date)
        }
        
    }
}





