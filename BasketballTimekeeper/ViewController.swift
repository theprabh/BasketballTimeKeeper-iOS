//
//  ViewController.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 8/22/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import UIKit
import SwiftySound

class ViewController: UIViewController, UITextFieldDelegate {
    
    var team1Points = 0
    var team1Timeouts = 6
    var team1Fouls = 0
    
    var team2Points = 0
    var team2Timeouts = 6
    var team2Fouls = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var halfLabel: UILabel!
    var half = 1
    var totalTime = 1200
    var countdownTimer = Timer()
    var isTimerRunning = false
    var isGameOver = false
    
    
    @IBOutlet weak var team1Text: UITextField!
    @IBOutlet weak var team1PointsLabel: UILabel!
    @IBOutlet weak var team1TimeoutsLabel: UILabel!
    @IBOutlet weak var team1FoulsLabel: UILabel!

    
    @IBOutlet weak var team2Text: UITextField!
    @IBOutlet weak var team2PointsLabel: UILabel!
    @IBOutlet weak var team2TimeoutsLabel: UILabel!
    @IBOutlet weak var team2FoulsLabel: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.team1Text.delegate = self
        self.team2Text.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // Closes keyboard after return is hit
    func textFieldShouldReturn(_ text: UITextField) -> Bool {
        text.resignFirstResponder()
        return true
    }
    
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
    
    @IBAction func alert() {
        let alert = UIAlertController(title: "Are you sure you want to reset?", message: "Press yes to reset back to the start of a new game.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.resetTimer()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // Resets timer back to 20:00 and half to 1
    func resetTimer() {
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
        halfLabel.text = "1"
        timerLabel.text = "20:00"
        totalTime = 1200
    }

    @IBAction func startButton(button: UIButton) {
        if !isTimerRunning{
            isTimerRunning = true
            runTimer()
        } else if isGameOver == true{
            self.showToast(message: "Please reset")
        } else {
            self.showToast(message: "Timer already started")
        }
        
    }
    
    @IBAction func pauseButton(button: UIButton) {
        if isTimerRunning{
            isTimerRunning = false
            countdownTimer.invalidate()
        } else if isGameOver == true{
            self.showToast(message: "Please reset")
        } else {
            self.showToast(message: "Timer already paused")
        }
        
    }
    
    func timeFormat(totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    // Shows message at bottom that eventually dissapears
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
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
            self.showToast(message: "Game is over")
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
            self.showToast(message: "Game is over")
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
            self.showToast(message: "Game is over")
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
                    self.showToast(message: "No timeouts remaining")
                }
                
            case 2:
                if team2Timeouts > 0 {
                    team2Timeouts -= 1
                    team2TimeoutsLabel.text = String(team2Timeouts)
                } else {
                    self.showToast(message: "No timeouts remaining")
                }
            default:
                return
            }
        } else {
            self.showToast(message: "Game is over")
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
            self.showToast(message: "Game is over")
        }
        
    }
}

