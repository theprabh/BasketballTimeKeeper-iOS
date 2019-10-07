//
//  TeamManager.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/4/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import Foundation
import RealmSwift

class Team: Object {
    let players = List<Player>
    @objc dynamic var name = String()
}

class Player: Object {
    @objc dynamic var name = String()
    @objc dynamic var age = Int()
}


