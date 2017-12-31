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

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Task.loadTasks().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.taskCell, for: indexPath) as! TaskTableViewCell
        taskCell.task = Task.loadTasks()[indexPath.row]
        return taskCell
    }
}
