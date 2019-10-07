//
//  PeriodLengthViewController.swift
//  BasketballTimekeeper
//
//  Created by Prabhjot S. Mattu on 9/12/19.
//  Copyright © 2019 Prabhjot S. Mattu. All rights reserved.
//

import UIKit

protocol PeriodLengthViewControllerDelegate: class {
    func periodLengthViewControllerDidCancel(_ controller: PeriodLengthViewController)
    func periodLengthViewController(_ controller: PeriodLengthViewController, didFinishSelecting newLength: Int)
}

class PeriodLengthViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var periodPicker: UIPickerView!
    var pickerData: [String] = []
    weak var delegate: PeriodLengthViewControllerDelegate?
    var previousLength: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        self.periodPicker.delegate = self
        self.periodPicker.dataSource = self
        
        for i in 1 ... 20{
            pickerData.append("\(i) minutes")
        }
        
        periodPicker.selectRow(previousLength - 1, inComponent: 0, animated: true)
        
        
    }
    
    @IBAction func cancel() {
        delegate?.periodLengthViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let currentLength = periodPicker.selectedRow(inComponent: 0) + 1
        delegate?.periodLengthViewController(self, didFinishSelecting: currentLength)
    }
    


    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return myTitle
    }

}


