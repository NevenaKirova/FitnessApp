//
//  CalendarExerciseTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 1/13/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class CalendarExerciseTableViewCell: UITableViewCell {
    @IBOutlet weak var muscleGroupImage: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
