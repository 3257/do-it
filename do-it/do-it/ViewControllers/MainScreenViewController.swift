//
//  MainScreenViewController.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController {

    // MARK: - Outlets and outlet functions
    @IBOutlet weak var tasksTableView: UITableView!

    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Identifiers.showAddTask, sender: nil)
    }
    @IBAction func didTapSettingsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Identifiers.showSettings, sender: nil)
    }

    // MARK: - Functions
    fileprivate func handleTaskDeletion(_ taskTitle: String) {
        // Add alert controller
        let alertController = UIAlertController(title: "Are you sure you want to delete \(taskTitle)?", message: nil, preferredStyle: .alert)
        // Ok
        let okAction = UIAlertAction(title: "Sure", style: .destructive, handler: { [unowned self] _ in
            self.deleteTask(by: taskTitle, completion: {
                self.tasksTableView.reloadData()
            })
        })
        // Cancel
        let cancelAction = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
        // Add actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - View Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.showAddTask,
            let addAddTaskVC = segue.destination as? AddTaskViewController {
            addAddTaskVC.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - AddTaskViewControllerDelegate
extension MainScreenViewController: AddTaskViewControllerDelegate {
    func didSaveTask() {
        tasksTableView.reloadData()
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Task.loadTasks().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.taskCell, for: indexPath) as! TaskTableViewCell
        taskCell.task = loadTasks()[indexPath.row]
        return taskCell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return tableView == tasksTableView
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let taskTitle = loadTasks()[indexPath.row].title {
                handleTaskDeletion(taskTitle)
            }
        }
    }
}

// MARK: - Tasks functions
extension MainScreenViewController  {
    func loadTasks() -> [Task] {
        return Task.loadTasks()
    }
    func deleteTask(by title: String, completion: @escaping () -> ()) {
        Task.deleteTask(title: title, completion: completion)
    }
}
