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
    
    func newGameViewController(_ controller: NewGameViewController, didFinishSelecting gameLength: Int, half: Bool) {
        //print("Game Length: \(gameLength)")
        gameTime = gameLength
        isHalf = half
    }
    
    weak var delegate: GameViewControllerDelegate?
    
    
    var team1Points = 0
    var team1Timeouts = 6
    var team1Fouls = 0
    var team2Points = 0
    var team2Timeouts = 6
    var team2Fouls = 0
    var pointsSwitchEnabled = true
    var timeoutsSwitchEnabled = false
    var foulsSwitchEnabled = true
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var pointsSwitch: UISegmentedControl!
    @IBOutlet weak var timeoutsSwitch: UISegmentedControl!
    @IBOutlet weak var foulsSwitch: UISegmentedControl!
    @IBOutlet weak var timeoutButton1: UIButton!
    @IBOutlet weak var timeoutButton2: UIButton!
    @IBOutlet weak var foulButton1: UIButton!
    @IBOutlet weak var foulButton2: UIButton!
    @IBOutlet weak var periodText: UILabel!
    
    var period = 1
    var isHalf = true
    var gameTime = 0
    var startTime = 0
    var countdownTimer = Timer()
    var gameStarted = false
    var isTimerRunning = false
    var isGameOver = false
    var isPeriodOver = false
    
    let gameOverAlert = UIAlertController(title: "Game Over", message: "The game is over, please press End Game", preferredStyle: .alert)
    let timeoutAlert = UIAlertController(title: "No Timeouts", message: "There are no timeouts remaining", preferredStyle: .alert)
    
    @IBOutlet weak var timerButton: UIButton!
    
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
        if isHalf {
            periodText.text = "Half:"
        } else {
            periodText.text = "Quarter:"
        }
        gameTime *= 60
        startTime = gameTime
        periodLabel.text = "1"
        timerLabel.text = "\(timeFormat(totalSeconds: startTime))"
        gameOverAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        timeoutAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        team1NameLabel.text = "\(gameTime)"
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        playPauseButton.imageEdgeInsets = UIEdgeInsets(top: 70,left: 70,bottom: 70,right: 70)

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func reset() {
        let alert = UIAlertController(title: "Do you want to Reset?", message: "Press yes to reset back to the start of a new game.", preferredStyle: .alert)
        
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
        period = 1
        periodLabel.text = "1"
        timerLabel.text = "\(timeFormat(totalSeconds: startTime))"
        gameTime = startTime
    }
    
    // MARK: - Switches
    
    @IBAction func pointsSwitchIndexChanged(_ sender: Any) {
        switch pointsSwitch.selectedSegmentIndex {
        case 0:
            pointsSwitchEnabled = true
        case 1:
            pointsSwitchEnabled = false
        default:
            pointsSwitchEnabled = true
        }
    }
    
    @IBAction func timeoutsSwitchIndexChanged(_ sender: Any) {
        switch timeoutsSwitch.selectedSegmentIndex {
        case 0:
            timeoutsSwitchEnabled = true
            timeoutButton1.setTitle("+", for: .normal)
            timeoutButton2.setTitle("+", for: .normal)
        case 1:
            timeoutsSwitchEnabled = false
            timeoutButton1.setTitle("-", for: .normal)
            timeoutButton2.setTitle("-", for: .normal)
        default:
            timeoutsSwitchEnabled = false
            timeoutButton1.setTitle("-", for: .normal)
            timeoutButton2.setTitle("-", for: .normal)
        }
    }
    
    @IBAction func foulSwitchIndexChanged(_ sender: Any) {
        switch foulsSwitch.selectedSegmentIndex {
        case 0:
            foulsSwitchEnabled = true
            foulButton1.setTitle("+", for: .normal)
            foulButton2.setTitle("+", for: .normal)
        case 1:
            foulsSwitchEnabled = false
            foulButton1.setTitle("-", for: .normal)
            foulButton2.setTitle("-", for: .normal)
        default:
            foulsSwitchEnabled = true
            foulButton1.setTitle("+", for: .normal)
            foulButton2.setTitle("+", for: .normal)
        }
    }
    
    // MARK: - Timer Functions
    
    // Runs timer and calls updateTimer() every second
    func runTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        countdownTimer.invalidate()
    }
    
    // Updates timer depending on time left and half
    @objc func updateTimer() {
        timerLabel.text = "\(timeFormat(totalSeconds: gameTime))"
        
        if gameTime != 0 {
            gameTime -= 1
        } else if gameTime == 0 {
            countdownTimer.invalidate()
            Sound.play(file: "buzzer.wav")
            
            switch isHalf {
            case true:
                switch period {
                case 1:
                    period = 2
                    periodLabel.text = "2"
                case 2:
                    isGameOver = true
                    countdownTimer.invalidate()
                default:
                    break
                }
                timerLabel.text = "\(timeFormat(totalSeconds: startTime))"
                gameTime = startTime
                isTimerRunning = false
                if #available(iOS 13.0, *) {
                    timerButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            case false:
                switch period {
                case 1:
                    period = 2
                    periodLabel.text = "2"
                case 2:
                    period = 3
                    periodLabel.text = "3"
                case 3:
                    period = 4
                    periodLabel.text = "4"
                case 4:
                    isGameOver = true
                    countdownTimer.invalidate()
                    self.present(gameOverAlert, animated: true)
                default:
                    break
                }
                
                timerLabel.text = "\(timeFormat(totalSeconds: startTime))"
                gameTime = startTime
                isTimerRunning = false
                if #available(iOS 13.0, *) {
                    timerButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            default:
                break
            }
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
        if !isTimerRunning {
            isTimerRunning = true
            runTimer()
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        } else if isTimerRunning {
            isTimerRunning = false
            pauseTimer()
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
    }
     
    
    // MARK: - Game Functions
    
    //Adds 3 points to team depending on which button is pressed
    @IBAction func threePointer(button: UIButton) {
        if !isGameOver {
            if pointsSwitchEnabled {
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
                switch button.tag {
                case 1:
                    team1Points -= 3
                    if team1Points < 0 {
                        team1Points = 0
                    }
                    team1PointsLabel.text = String(team1Points)
                case 2:
                    team2Points -= 3
                    if team2Points < 0 {
                        team2Points = 0
                    }
                    team2PointsLabel.text = String(team2Points)
                default:
                    return
                }
            }
            
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 2 points to team depending on which button is pressed
    @IBAction func twoPointer(button: UIButton) {
        if !isGameOver {
            if pointsSwitchEnabled {
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
                switch button.tag {
                case 1:
                    team1Points -= 2
                    if team1Points < 0 {
                        team1Points = 0
                    }
                    team1PointsLabel.text = String(team1Points)
                case 2:
                    team2Points -= 2
                    if team2Points < 0 {
                        team2Points = 0
                    }
                    team2PointsLabel.text = String(team2Points)
                default:
                    return
                }
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 1 points to team depending on which button is pressed
    @IBAction func freeThrow(button: UIButton) {
        if !isGameOver {
            if pointsSwitchEnabled {
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
                switch button.tag {
                case 1:
                    team1Points -= 1
                    if team1Points < 0 {
                        team1Points = 0
                    }
                    team1PointsLabel.text = String(team1Points)
                case 2:
                    team2Points -= 1
                    if team2Points < 0 {
                        team2Points = 0
                    }
                    team2PointsLabel.text = String(team2Points)
                default:
                    return
                }
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Subtracts 1 timeout to team depending on which button is pressed
    @IBAction func timeout(button: UIButton) {
        if !isGameOver {
            if !timeoutsSwitchEnabled {
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
                switch button.tag {
                case 1:
                    team1Timeouts += 1
                    team1TimeoutsLabel.text = String(team1Timeouts)
                case 2:
                    team2Timeouts += 1
                    team2TimeoutsLabel.text = String(team2Timeouts)
                default:
                    return
                }
            }
        } else {
            self.present(gameOverAlert, animated: true)
        }
    }
    
    //Adds 1 foul to team depending on which button is pressed
    @IBAction func foul(button: UIButton) {
        if !isGameOver {
            if foulsSwitchEnabled {
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
                switch button.tag {
                case 1:
                    team1Fouls -= 1
                    if team1Fouls < 0 {
                        team1Fouls = 0
                    }
                    team1FoulsLabel.text = String(team1Fouls)
                case 2:
                    team2Fouls -= 1
                    if team2Fouls < 0 {
                        team2Fouls = 0
                    }
                    team2FoulsLabel.text = String(team2Fouls)
                default:
                    return
                }
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
