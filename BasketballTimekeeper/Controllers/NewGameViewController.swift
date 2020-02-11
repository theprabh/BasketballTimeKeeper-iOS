//
//  NewGameViewController.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 9/11/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import UIKit

protocol NewGameViewControllerDelegate: class {
    func newGameViewController(_ controller: NewGameViewController, didFinishSelecting gameLength: Int)
}

class NewGameViewController: UITableViewController, PeriodLengthViewControllerDelegate, GameViewControllerDelegate {
    
    func gameViewControllerDidCancel(_ controller: GameViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Period Length Delegates
    
    func periodLengthViewControllerDidCancel(_ controller: PeriodLengthViewController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func periodLengthViewController(_ controller: PeriodLengthViewController, didFinishSelecting newLength: Int) {
        length = newLength
        lengthLabel.text = "\(newLength) minutes"
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: NewGameViewControllerDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    var length = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewGameItem")
        
        let currentDate = Date()
        let dateString = DateFormatter.localizedString(from: currentDate, dateStyle: .full, timeStyle: .none)
        dateLabel.text = dateString

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            switch cell.tag {
            case 4:
                //print("hello")
                break
            default:
                //print("buy")
                break
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.init(red: 38, green: 38, blue: 38, alpha: 0)
        }
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectPeriodLength" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! PeriodLengthViewController
            controller.delegate = self
            controller.previousLength = length
        } else if segue.identifier == "StartGame" {
            print("start game")
            let controller = segue.destination as! GameViewController
            controller.delegate = self
            controller.gameTime = length
            //controller.delegate = self
        }
    }
 

}
