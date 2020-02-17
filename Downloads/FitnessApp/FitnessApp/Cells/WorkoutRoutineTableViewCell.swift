//
//  WorkoutRoutineTableViewCell.swift
//  FitnessApp
//
//  Created by Mitko on 1/15/20.
//  Copyright © 2020 Mitko. All rights reserved.
//

import UIKit

class WorkoutRoutineTableViewCell: UITableViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var routineTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
