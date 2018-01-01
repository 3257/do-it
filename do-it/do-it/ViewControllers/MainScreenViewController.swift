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
    private func handleTaskDeletion(_ taskTitle: String) {
        // Alert
        let alertController = UIAlertController(title: "Are you sure you want to delete \(taskTitle.capitalized)?", message: nil, preferredStyle: .alert)

        // Alert actions
        let okAction = UIAlertAction(title: "Sure", style: .destructive, handler: { _ in
            self.deleteTask(by: taskTitle, completion: {
                self.tasksTableView.reloadData()
            })
        })
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
            if let taskTitle = sender as? String {
                addAddTaskVC.taskTitle = taskTitle
            }
        }
    }
}

// MARK: - AddTaskViewControllerDelegate
extension MainScreenViewController: AddTaskViewControllerDelegate {
    func didUpdateTask() {
        tasksTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadTasks().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.taskCell, for: indexPath) as! TaskTableViewCell
        taskCell.task = loadTasks()[indexPath.row]
        return taskCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Identifiers.showAddTask, sender: loadTasks()[indexPath.row].title)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return tableView == tasksTableView
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let taskTitle = loadTasks()[indexPath.row].title else  { return [] }

        // Local constants
        let deleteTitle = "Delete"
        let editTitle = "Edit"

        // Add actions
        let delete = UITableViewRowAction(style: .destructive, title: deleteTitle) { (action, indexPath) in
            self.handleTaskDeletion(taskTitle)
        }

        let edit = UITableViewRowAction(style: .normal, title: editTitle) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.Identifiers.showAddTask, sender: taskTitle)
        }
        return [delete, edit]
    }
}
// MARK: - Task functions
extension MainScreenViewController {
    private func loadTasks() -> [Task] {
        // Return tasks with completed tasks at the front
        return Task.loadTasks().sorted { $0.isCompleted && !$1.isCompleted }
    }
    private func deleteTask(by title: String, completion: @escaping () -> ()) {
        Task.deleteTask(title: title, completion: completion)
    }
}
