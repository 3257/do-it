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
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var categoryView: UIView!

    var task: Task? { didSet { updateUI() } }

    func updateUI() {
        if let task = task {
            title.text = task.title
            if let taskCompletionDate = task.completionDate {
                completionDate.text = "due \((taskCompletionDate).toString(dateFormat: "EEE., MMM dd, YY"))"
            }
            categoryView.backgroundColor = ColorPallete.getColor(for: task.categoryColor)
            accessoryImageView.image = task.isCompleted ? #imageLiteral(resourceName: "approve-circular-button") : #imageLiteral(resourceName: "minus-sign-in-a-circle")
        }
    }
}
