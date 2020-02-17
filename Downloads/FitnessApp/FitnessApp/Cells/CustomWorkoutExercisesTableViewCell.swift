//
//  CustomWorkoutExercisesTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 1/15/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class CustomWorkoutExercisesTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
