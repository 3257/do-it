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
            if let taskTitle = sender as? String {
                addAddTaskVC.taskTitle = taskTitle
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Enables editing only for the selected table view, if you have multiple table views
        return tableView == tasksTableView
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let taskTitle = self.loadTasks()[indexPath.row].title else  { return [] }

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.handleTaskDeletion(taskTitle)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.Identifiers.showAddTask, sender: taskTitle)
        }
        return [delete, edit]
    }
}
// MARK: - Task functions
extension MainScreenViewController {
    private func loadTasks() -> [Task] {
        var tasks = Task.loadTasks()
        tasks.sort { $0.isCompleted && !$1.isCompleted }
        return tasks
    }
    private func deleteTask(by title: String, completion: @escaping () -> ()) {
        Task.deleteTask(title: title, completion: completion)
    }
}
