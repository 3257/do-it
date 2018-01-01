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
        // Edit task only if task title provided in segue
        taskTitle != nil ? editTask() : saveTask()
    }

    // MARK: - Variables
    weak var delegate: AddTaskViewControllerDelegate?
    var taskTitle: String?

    private var selectedColor = Constants.categoryColors[0]

    private lazy var isTaskCompleted: Bool = {
        return completionSegmentedControl.titleForSegment(at: completionSegmentedControl.selectedSegmentIndex) == "Completed"
    }()

    // MARK: - Functions
    private func updateUI(for taskTitle: String?) {
        if let taskTitle = taskTitle, let task = Task.loadTask(by: taskTitle) {
            // Enable all segments of completionSegmentedControl and disable titleTextField
            completionSegmentedControl.enableAllSegments()
            titleTextField.isEnabled = false
            titleTextField.backgroundColor = .lightGray

            // Update relevant UI
            titleTextField.text = task.title
            categoryTextField.text = task.categoryName
            selectedColor = task.categoryColor ?? "Gray"
            if let colorPickerViewIndex = Constants.categoryColors.index(where: { $0 == task.categoryColor }) {
                colorPickerView.selectRow(colorPickerViewIndex, inComponent: 0, animated: true)
            }
            completionDatePicker.date = task.completionDate ?? Date()
            completionSegmentedControl.selectedSegmentIndex = task.isCompleted ? 0 : 1
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: taskTitle)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
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

// MARK: - Task Functions
extension AddTaskViewController {
    private func editTask() {
        Task.editTask(title: titleTextField.text ?? "",
                        categoryName: categoryTextField.text ?? "",
                        categoryColor: selectedColor,
                        completionDate: completionDatePicker.date,
                        isCompleted: isTaskCompleted,
                        completion: {
                            self.delegate?.didUpdateTask()
                            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func saveTask() {
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
