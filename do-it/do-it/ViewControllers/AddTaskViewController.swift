//
//  AddTaskViewController.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate: class {
    func didUpdateTask()
}

class AddTaskViewController: UIViewController {
    
    // MARK: - Outlets and outlet functions
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    @IBOutlet weak var completionDatePicker: UIDatePicker!
    @IBOutlet weak var completionSegmentedControl: UISegmentedControl!

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        if taskID != nil {
            Task.updateTask(title: titleTextField.text ?? "",
                            categoryName: categoryTextField.text ?? "",
                            categoryColor: selectedColor,
                            completionDate: completionDatePicker.date,
                            isCompleted: isTaskCompleted,
                            completion: {
                                self.delegate?.didUpdateTask()
                                self.navigationController?.popViewController(animated: true)
            })
        } else {
            Task.saveTask(title: titleTextField.text ?? "",
                          categoryName: categoryTextField.text ?? "",
                          categoryColor: selectedColor,
                          completionDate: completionDatePicker.date,
                          isCompleted: isTaskCompleted,
                          completion: {
                            self.delegate?.didUpdateTask()
                            self.navigationController?.popViewController(animated: true)
            })
        }
    }


// MARK: - Variables
weak var delegate: AddTaskViewControllerDelegate?

    fileprivate func updateUI(for taskID: Int?) {
        if let taskID = taskID {
            let task = Task.loadTasks()[taskID]
            titleTextField.text = task.title
            categoryTextField.text = task.categoryName

            if let colorPickerViewIndex = Constants.categoryColors.index(where: { (color) -> Bool in
                color == task.categoryColor
            }) {
                colorPickerView.selectRow(colorPickerViewIndex, inComponent: 0, animated: true)
            }
            completionDatePicker.date = task.completionDate ?? Date()
            completionSegmentedControl.selectedSegmentIndex = task.isCompleted ? 0 : 1
        }
    }

    var taskID: Int?
    var selectedColor = Constants.categoryColors[0]

    lazy var isTaskCompleted: Bool = {
        return completionSegmentedControl.titleForSegment(at: completionSegmentedControl.selectedSegmentIndex) == "Completed"
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: taskID)
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
