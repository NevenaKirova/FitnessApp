//
//  ReusableExerciseTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 1/13/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class ReusableExerciseTableViewCell: UITableViewCell {
 
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var muscleGroupImage: UIImageView!
    
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
