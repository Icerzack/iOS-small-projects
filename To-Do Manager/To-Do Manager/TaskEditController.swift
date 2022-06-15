//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Max Kuznetsov on 27.04.2022.
//

import UIKit

class TaskEditController: UITableViewController {

    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    @IBOutlet var taskStatusSwitch: UISwitch!
    
    private var taskTitles: [TaskPriority:String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle?.text = taskText
        taskTypeLabel.text = taskTitles[taskType]
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem){
        let title = taskTitle.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        if title == ""{
            let ac = UIAlertController(title: "Пустое имя", message: "Введите хоть что-нибудь", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ОК", style: .default))
            present(ac, animated: true)
            return
        } else {
            let type = taskType
            let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
            doAfterEdit?(title, type, status)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen"{
            let destination = segue.destination as! TaskTypeController
            destination.selectedType = taskType
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                taskTypeLabel.text = taskTitles[taskType]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
