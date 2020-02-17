//
//  WorkoutModel.swift
//  FitnessApp
//
//  Created by Mitko on 12/21/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit

struct Exercise {
    var exerciseName : String
    var repetitions : String
    var muscleGroup : String
    var timeOfCreation: Double
    var sets : String
}

struct Workout {
    var exercises : [Exercise]
    
}

class WorkoutManager {
    static let shared = WorkoutManager()
    var exercises : [Exercise] = []
    var workouts : [String] = []
    var numberOfExercises : Int = 0
    var numberOfWorkouts : Int = 0
    var date : String = ""
    var newExercise : Exercise = Exercise(exerciseName: "", repetitions: "", muscleGroup: "", timeOfCreation: 0.0, sets: "")
    
    let muscleGroups : [String] = ["Shoulders", "Biceps",
    "Abs","Tighs", "Calves", "Back", "Chest"]
    private init() { }
}


