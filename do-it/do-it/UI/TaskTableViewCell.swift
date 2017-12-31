//
//  TaskTableViewCell.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var completionDate: UILabel!

    var task: Task? { didSet { updateUI() } }

    func updateUI() {
        if let task = task {
            title.text = task.title
            if let taskCompletionDate = task.completionDate {
                completionDate.text = (taskCompletionDate).toString(dateFormat: "dd-MMM-yyyy")
            }
            backgroundColor = ColorPallete.getColor(for: task.categoryColor)
            accessoryType = task.isCompleted ? .checkmark : .none
        }
    }
}
