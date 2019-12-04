//
//  GameViewController.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 10/9/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import UIKit
import SwiftySound

protocol GameViewControllerDelegate: class {
    func gameViewControllerDidCancel(_ controller: GameViewController)
}

class GameViewController: UIViewController, NewGameViewControllerDelegate {
    
    func newGameViewController(_ controller: NewGameViewController, didFinishSelecting gameLength: Int) {
        totalTime = gameLength
    }
    
    weak var delegate: GameViewControllerDelegate?
    
    
    var team1Points = 0
    var team1Timeouts = 6
    var team1Fouls = 0
    var team2Points = 0
    var team2Timeouts = 6
    var team2Fouls = 0
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var pointsSwitch: UISegmentedControl!
    @IBOutlet weak var timeoutsSwitch: UISegmentedControl!
    @IBOutlet weak var foulsSwitch: UISegmentedControl!
    var half = 1
    var totalTime = 1200
    var countdownTimer = Timer()
    var isTimerRunning = false
    var isGameOver = false
    let gameOverAlert = UIAlertController(title: "Game Over", message: "The game is over, please press End Game", preferredStyle: .alert)
    let timeoutAlert = UIAlertController(title: "No Timeouts", message: "There are no timeouts remaining", preferredStyle: .alert)
    
    // Team 1 Labels
    @IBOutlet weak var team1NameLabel: UILabel!
    @IBOutlet weak var team1PointsLabel: UILabel!
    @IBOutlet weak var team1TimeoutsLabel: UILabel!
    @IBOutlet weak var team1FoulsLabel: UILabel!
    
    // Team 2 Labels
    @IBOutlet weak var team2NameLabel: UILabel!
    @IBOutlet weak var team2PointsLabel: UILabel!
    @IBOutlet weak var team2TimeoutsLabel: UILabel!
    @IBOutlet weak var team2FoulsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        timeoutAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        team1NameLabel.text = "\(totalTime)"
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        playPauseButton.imageEdgeInsets = UIEdgeInsets(top: 70,left: 70,bottom: 70,right: 70)

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func reset() {
        let alert = UIAlertController(title: "Do you want to Rest?", message: "Press yes to reset back to the start of a new game.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // Resets back to a new game
    func resetGame() {
        countdownTimer.invalidate()
        
        team1Points = 0
        team1Timeouts = 6
        team1Fouls = 0
        team1PointsLabel.text = "0"
        team1TimeoutsLabel.text = "6"
        team1FoulsLabel.text = "0"
        
        team2Points = 0
        team2Timeouts = 6
        team2Fouls = 0
        team2PointsLabel.text = "0"
        team2TimeoutsLabel.text = "6"
        team2FoulsLabel.text = "0"
        
        isTimerRunning = false
        isGameOver = false
        half = 1
        periodLabel.text = "1"
        timerLabel.text = "20:00"
        totalTime = 1200
    }
    
    // MARK: - Timer Functions
    
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
            periodLabel.text = "2"
            timerLabel.text = "20:00"
            totalTime = 1200
            isTimerRunning = false
        } else {
            Sound.play(file: "buzzer.wav")
            isGameOver = true
            countdownTimer.invalidate()
        }
    }
    
    func timeFormat(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    @IBAction func playPauseTimer(button: UIButton) {
        print("helllllloooo")
        if !isTimerRunning {
            isTimerRunning = true
            runTimer()
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
    }
     
    
    // MARK: - Game Functions
    
    //Adds 3 points to team depending on which button is pressed
    @IBAction func threePointer(button: UIButton) {
        if !isGameOver {
            switch button.tag {
            case 1:
                team1Points += 3
                team1PointsLabel.text = String(team1Points)
            case 2:
                team2Points += 3
                team2PointsLabel.text = String(team2Points)
            default:
                return
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 2 points to team depending on which button is pressed
    @IBAction func twoPointer(button: UIButton) {
        if !isGameOver {
            switch button.tag {
            case 1:
                team1Points += 2
                team1PointsLabel.text = String(team1Points)
            case 2:
                team2Points += 2
                team2PointsLabel.text = String(team2Points)
            default:
                return
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 1 points to team depending on which button is pressed
    @IBAction func freeThrow(button: UIButton) {
        if !isGameOver {
            switch button.tag {
            case 1:
                team1Points += 1
                team1PointsLabel.text = String(team1Points)
            case 2:
                team2Points += 1
                team2PointsLabel.text = String(team2Points)
            default:
                return
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Subtracts 1 timeout to team depending on which button is pressed
    @IBAction func timeout(button: UIButton) {
        if !isGameOver {
            switch button.tag {
            case 1:
                if team1Timeouts > 0 {
                    team1Timeouts -= 1
                    team1TimeoutsLabel.text = String(team1Timeouts)
                } else {
                    self.present(timeoutAlert, animated: true)
                }
                
            case 2:
                if team2Timeouts > 0 {
                    team2Timeouts -= 1
                    team2TimeoutsLabel.text = String(team2Timeouts)
                } else {
                    self.present(timeoutAlert, animated: true)
                }
            default:
                return
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 1 foul to team depending on which button is pressed
    @IBAction func foul(button: UIButton) {
        if !isGameOver {
            switch button.tag {
            case 1:
                team1Fouls += 1
                team1FoulsLabel.text = String(team1Fouls)
            case 2:
                team2Fouls += 1
                team2FoulsLabel.text = String(team2Fouls)
            default:
                return
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
        
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel() {
        delegate?.gameViewControllerDidCancel(self)
    }

    
    

}
