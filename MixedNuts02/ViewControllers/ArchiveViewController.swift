//
//  ViewController.swift
//  MixedNuts02
//
//  Created by Default User on 3/25/24.
//

import UIKit
import Firebase

class ArchiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskTable: SelfSizedTableView!
    
    var db: Firestore!
    
    var taskList: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskList = [Task]()
        
        db = Firestore.firestore()
        
        taskTable.register(UITableViewCell.self, forCellReuseIdentifier: "task")
        taskTable.delegate = self
        taskTable.dataSource = self

        db.collection("tasks").whereField("isComplete", isEqualTo: true).order(by: "dueDate").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let task = Task(snapshot: document)
                    self.taskList!.append(task)
                }
                self.taskTable.reloadData();
            }
        }


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        if let viewWithTag = cell.contentView.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
        }
        let task = taskList![indexPath.row]
        
        let taskView = DesignableTaskView.instanceFromNib(setTask: task)
        taskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.heightAnchor.constraint(equalToConstant: 81).isActive = true
        taskView.tag = 100
        cell.contentView.addSubview(taskView)
        return cell
    }

}
