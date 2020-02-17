//
//  ExerciseCell.swift
//  FitnessApp
//
//  Created by Mitko on 1/11/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var muscleGroupImage: UIImageView!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
