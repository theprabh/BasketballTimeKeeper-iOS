//
//  GameViewController.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/9/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate: class {
    func gameViewControllerDidCancel(_ controller: GameViewController)
}

class GameViewController: UIViewController, NewGameViewControllerDelegate {
    
    func newGameViewController(_ controller: NewGameViewController, didFinishSelecting gameLength: Int) {
        length = gameLength
    }
    
    weak var delegate: GameViewControllerDelegate?
    
    var length = 0
    var countdownTimer = Timer()
    @IBOutlet weak var team1score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team1score.text = "\(length)"

        // Do any additional setup after loading the view.
    }
    /*
    // Runs timer and calls updateTimer() every second
    func runTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    // Updates timer depending on time left and half
    @objc func updateTimer() {
        timerLabel.text = "\(timeFormat(totalSeconds: totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else if totalTime == 0 && half == 1{
            countdownTimer.invalidate()
            Sound.play(file: "buzzer.wav")
            half = 2
            halfLabel.text = "2"
            timerLabel.text = "20:00"
            totalTime = 1200
            isTimerRunning = false
        } else {
            Sound.play(file: "buzzer.wav")
            isGameOver = true
            countdownTimer.invalidate()
        }
    }
     */
    
    // MARK: - Navigation
    
    @IBAction func cancel() {
        delegate?.gameViewControllerDidCancel(self)
    }

    
    

}
