//
//  TeamManager.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/9/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import Foundation
import RealmSwift

class TeamManager: NSObject {
    static let global = TeamManager()
    
    let realm = try! Realm()
    var teams: Results<Team>
    
    private override init() {
        self.teams = realm.objects(Team.self)
        super.init()
    }
}

class Team: Object {
    let players = List<Player>()
    @objc dynamic var name = ""
}

class Player: Object {
    @objc dynamic var name = String()
    @objc dynamic var age = Int()
}
