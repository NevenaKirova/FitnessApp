//
//  CardModel.swift
//  FitnessApp
//
//  Created by Mitko on 12/19/19.
//  Copyright © 2019 Mitko. All rights reserved.
//

import UIKit
struct CardModel {
    var backgroundImage: UIImage
    var label: String
}

class CardsManager {
    static var shared = CardsManager()
    private var cards : [CardModel] = [
        CardModel(backgroundImage: #imageLiteral(resourceName: "workout"), label: "Workout Calendar"),
        CardModel(backgroundImage: #imageLiteral(resourceName: "workout"), label: "Workout Calendar"),
        CardModel(backgroundImage: #imageLiteral(resourceName: "workout"), label: "Workout Calendar"),
        CardModel(backgroundImage: #imageLiteral(resourceName: "workout"), label: "Workout Calendar")
    ]
}
