//
//  AddTaskViewController.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - Outlets and outlet functions
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var completionDatePicker: UIDatePicker!

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        Task.saveTask(title: titleTextField.text ?? "", categoryName: categoryTextField.text ?? "", categoryColor: selectedColor, completionDate: completionDatePicker.date, isCompleted: false)
    }

    // MARK: - Variables
    var selectedColor = Constants.categoryColors[0]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.categoryColors.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.categoryColors[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = Constants.categoryColors[row]
    }
}
