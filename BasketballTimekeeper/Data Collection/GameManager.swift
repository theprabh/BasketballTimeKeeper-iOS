//
//  GameManager.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/4/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import Foundation
import RealmSwift

class Game: Object {
    let team1 = Team()
    let team2 = Team()
    @objc dynamic var date = String()
    @objc dynamic var team1Score = Int()
    @objc dynamic var team2Score = Int()
    
}
