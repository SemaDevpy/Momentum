//
//  MainViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/31/21.
//

import UIKit
import Firebase
import FirebaseFirestore

enum TaskStatus: String {
    case active
    case completed
}

class TasksViewController: UIViewController {
    
    let db = Firestore.firestore()
    var tasks: [TaskList] = []
    var mainSectionHeader = MainSectionHeader()
    
    //MARK: - UIElements
    
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myLabel : UILabel = {
        let label = UILabel()
        label.text = "215"
        label.font = label.font.withSize(18)
        label.textColor =  UIColor(red: 0.902, green: 0.682, blue: 0.145, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add a Task", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.backgroundColor = UIColor(red: 0.771, green: 0.53, blue: 0.247, alpha: 1).cgColor
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    let userTextfield : UITextField = {
        let textField = UITextField()
        textField.layer.backgroundColor = UIColor(red: 0.101, green: 0.137, blue: 0.192, alpha: 1).cgColor
        textField.font = textField.font?.withSize(18)
        textField.textColor = .white
        textField.layer.cornerRadius = 3
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.text = "John Peterson"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //tableView
    let taskTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "myCustomColor")
        tableView.register(MyViewCell.self, forCellReuseIdentifier: MyViewCell.identifier)
        tableView.register(MainSectionHeader.self, forHeaderFooterViewReuseIdentifier: "MainSectionHeader")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var selectedIndexPaths: [IndexPath] = []
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.sectionHeaderHeight = 0.0;
        taskTableView.sectionFooterHeight = 0.0;
        
        view.addSubview(userTextfield)
        view.addSubview(taskTableView)
        view.addSubview(addButton)
        userTextfield.addSubview(myImageView)
        userTextfield.addSubview(myLabel)
        
        //reading from the Firestore
        loadTasks()
        
        //constraints
        let constraints = [
            userTextfield.heightAnchor.constraint(equalToConstant: 53),
            userTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            taskTableView.topAnchor.constraint(equalTo: userTextfield.bottomAnchor, constant: 16),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 53),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            myImageView.widthAnchor.constraint(equalToConstant: 20),
            myImageView.heightAnchor.constraint(equalToConstant: 20),
            myImageView.topAnchor.constraint(equalTo: userTextfield.topAnchor, constant: 16),
            myImageView.trailingAnchor.constraint(equalTo: userTextfield.trailingAnchor, constant: -16),
            
            
            myLabel.topAnchor.constraint(equalTo: userTextfield.topAnchor, constant: 16),
            myLabel.trailingAnchor.constraint(equalTo: myImageView.leadingAnchor, constant: -8),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - add a task
    @objc func addTapped(){
        self.navigationController?.present(CreateTaskViewController(), animated: true, completion: nil)
    }
    
    //MARK: - Read of CRUD
    //LOADING TASKS
    func loadTasks() {
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        db.collection(K.Fstore.Users)
            .document(userId)
            .collection(K.Fstore.collectionName)
            .whereField(K.Fstore.userField, isEqualTo: userId).addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments =  querySnapshot?.documents {
                        self.tasks.removeAll()
                        var tempTasks: [Task] = []
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let title = data[K.Fstore.titleField] as? String,
                               let description = data[K.Fstore.descriptionField] as? String,
                               let priority = data[K.Fstore.priorityField] as? Int,
                               let id = data[K.Fstore.taskID] as? String,
                               let user = data[K.Fstore.userField] as? String,
                               let status = data[K.Fstore.status] as? String {
                                
                                let newTask = Task(user: user, title: title, description: description, priority: priority, taskID: id, status: status)
                                tempTasks.append(newTask)
                            }
                        }
                        
                        let sortedTasks = tempTasks.sorted(by: { $0.priority > $1.priority })
                        
                        let taskList = TaskList(status: .active, tasks: sortedTasks)
                        self.tasks.append(taskList)
                        self.loadCompletedTasks()
                    }
                }
            }
    }
    
    
    //LOADING COMPLETED TASKS
    func loadCompletedTasks() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection(K.Fstore.Users)
            .document(userId)
            .collection(K.Fstore.completedTasks)
            .whereField(K.Fstore.userField, isEqualTo: userId).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments =  querySnapshot?.documents {
                    
                    var tempTasks: [Task] = []
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let title = data[K.Fstore.titleField] as? String,
                           let description = data[K.Fstore.descriptionField] as? String,
                           let priority = data[K.Fstore.priorityField] as? Int,
                           let id = data[K.Fstore.taskID] as? String,
                           let user = data[K.Fstore.userField] as? String,
                           let status = data[K.Fstore.status] as? String {
                            
                            let newTask = Task(user: user, title: title, description: description, priority: priority, taskID: id, status: status)
                            tempTasks.append(newTask)
                        }
                    }
                    
                    let taskList = TaskList(status: .completed, tasks: tempTasks)
                    self.tasks.append(taskList)
                    
                    DispatchQueue.main.async {
                        self.taskTableView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: - UITablewViewDelegate, UITablewViewDataSource

extension TasksViewController : UITableViewDataSource, UITableViewDelegate{
    //TableView main methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyViewCell.identifier, for: indexPath) as! MyViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor(named: "myCustomColor")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.myLabel.text = tasks[indexPath.section].tasks[indexPath.row].title
        cell.descriptionLabel.text = tasks[indexPath.section].tasks[indexPath.row].description
        
        switch tasks[indexPath.section].status {
        case .active:
            cell.myImageView.image = UIImage(named: "unchecked")
            switch tasks[indexPath.section].tasks[indexPath.row].priority {
            case 1:
                cell.myView.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1)
            case 2:
                cell.myView.backgroundColor = UIColor(red: 0.765, green: 0.659, blue: 0.388, alpha: 1)
            default:
                cell.myView.backgroundColor = UIColor(red: 0.858, green: 0.39, blue: 0.347, alpha: 1)
            }
        case .completed:
            cell.myView.backgroundColor = UIColor(red: 21/255, green: 28/255, blue: 37/255, alpha: 1)
            cell.myImageView.image = UIImage(named: "checked")
        }
        
        if selectedIndexPaths.contains(indexPath) {
            cell.setupWith(isCollapsed: true)
        } else {
            cell.setupWith(isCollapsed: false)
        }
        
        return cell
    }
    //tableView additional methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedIndexPaths.firstIndex(where: { $0 == indexPath }) {
            selectedIndexPaths.remove(at: index)
        } else {
            selectedIndexPaths.append(indexPath)
        }
        tableView.reloadRows(at: selectedIndexPaths, with: .automatic)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == tasks.count - 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainSectionHeader") as! MainSectionHeader
            headerView.setupWith(text: "Completed")
            headerView.delegate = self
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == tasks.count - 1 {
            return 48
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
    }
}
//MARK: - MainSectionHeaderDelegate
extension TasksViewController : MainSectionHeaderDelegate{
    func didTapBackView() {
        print("Im Tapped in from Main View Controller!")
    }
}
extension TasksViewController : MyViewCellDelegate{
    func checkTapped(cell: MyViewCell) {
        guard let indexPath = taskTableView.indexPath(for: cell) else { return }
        let task = tasks[indexPath.section].tasks[indexPath.row]
        
        
//        db.collection(K.Fstore.Users)
//            .document(userID)
//            .collection(K.Fstore.collectionName)
//            .document("\(myId)")
        
        //adding to completed list
        db.collection(K.Fstore.Users)
            .document(task.user)
            .collection(K.Fstore.completedTasks)
            .document(task.taskID)
            .setData([K.Fstore.titleField : task.title, K.Fstore.userField : task.user, K.Fstore.descriptionField : task.description, K.Fstore.priorityField : task.priority, K.Fstore.taskID : task.taskID, K.Fstore.status : "completed"]) { (error) in
            if let e = error{
                print("issue saving data \(e)")
            }else{
                print("Document successfully transferred!")
            }
        }
        
        //deleting from the firestore
        db.collection(K.Fstore.Users)
            .document(task.user)
            .collection(K.Fstore.collectionName)
            .document(task.taskID)
            .delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                
                print("Document successfully removed!")
            }
        }
        taskTableView.reloadData()
        
    }
}
