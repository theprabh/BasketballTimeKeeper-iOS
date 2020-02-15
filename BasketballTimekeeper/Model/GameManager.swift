//
//  GameManager.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/4/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import Foundation
import RealmSwift

class GameManager: NSObject {

    static let global = GameManager()
    
    let realm = try! Realm()
    var games: Results<Game>
    
    private var currentGame: Game?
    
    var team1score = 0
    
    public override init() {
        self.games = realm.objects(Game.self)
        super.init()
    }
                   
}

class Game: Object {
    @objc dynamic var team1Name = String()
    @objc dynamic var team2Name = String()
    @objc dynamic var date = String()
    @objc dynamic var team1Score = Int()
    @objc dynamic var team2Score = Int()
}


