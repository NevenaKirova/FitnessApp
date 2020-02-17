//
//  ExerciseTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 12/22/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
//    var exersise: String = ""
//    var repetitions: 

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repetitions: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var muscleGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
