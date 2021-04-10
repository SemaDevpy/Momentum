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
    var userName : String = ""
    var score = 0
    var selectedIndexPaths: [IndexPath] = []
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
        label.text = "0"
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
    
    let userLabel : UILabel = {
        let label = UILabel()
        label.layer.backgroundColor = UIColor(red: 0.101, green: 0.137, blue: 0.192, alpha: 1).cgColor
        label.layer.cornerRadius = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Add your name"
        label.font = label.font.withSize(18)
        label.textColor =  .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let taskTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "myCustomColor")
        tableView.register(MyViewCell.self, forCellReuseIdentifier: MyViewCell.identifier)
        tableView.register(MainSectionHeader.self, forHeaderFooterViewReuseIdentifier: "MainSectionHeader")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
//MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
//MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        callGesture()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.sectionHeaderHeight = 0.0;
        taskTableView.sectionFooterHeight = 0.0;
        view.addSubview(userLabel)
        view.addSubview(taskTableView)
        view.addSubview(addButton)
        userLabel.addSubview(myImageView)
        userLabel.addSubview(myLabel)
        userLabel.addSubview(userNameLabel)
        
        //reading from the Firestore
        getProfile()
        loadTasks()
        
        let constraints = [
            userLabel.heightAnchor.constraint(equalToConstant: 53),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            taskTableView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 16),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 53),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            myImageView.widthAnchor.constraint(equalToConstant: 20),
            myImageView.heightAnchor.constraint(equalToConstant: 20),
            myImageView.topAnchor.constraint(equalTo: userLabel.topAnchor, constant: 16),
            myImageView.trailingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: -16),
            
            myLabel.topAnchor.constraint(equalTo: userLabel.topAnchor, constant: 16),
            myLabel.trailingAnchor.constraint(equalTo: myImageView.leadingAnchor, constant: -8),
            
            userNameLabel.topAnchor.constraint(equalTo: userLabel.topAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: userLabel.leadingAnchor, constant: 20),
        ]
        NSLayoutConstraint.activate(constraints)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//MARK: -  Create of CRUD
    @objc func addTapped(){
        self.navigationController?.present(CreateTaskViewController(), animated: true, completion: nil)
    }
    
//MARK: - Read of CRUD
    func getProfile() {
        guard let userId = Auth.auth().currentUser?.uid else{ return }
        db.collection(K.Fstore.Users).document(userId).addSnapshotListener { (documentSnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let safeData = documentSnapshot?.data(){
                    DispatchQueue.main.async {
                        self.userNameLabel.text = safeData[K.Fstore.name] as? String ?? "Add your name"
                        guard let safeScore = safeData[K.Fstore.scoreField] as? Int else { return }
                        self.score = safeScore
                        self.myLabel.text = "\(self.score)"
                    }
                }
            }
        }
    }
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
//MARK: - Gesture to add a name and Log User Out
    func callGesture(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(gestureFired(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        userLabel.addGestureRecognizer(gestureRecognizer)
        userLabel.isUserInteractionEnabled = true
    }
    
    @objc func gestureFired(_ gesture: UITapGestureRecognizer){
        let vc = LogOutViewController()
        vc.delegate = self
        vc.userName = userName
        vc.score = score
        self.navigationController?.pushViewController(vc, animated: true)
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
            cell.myImageViewRight.isHidden = true
            cell.myLabelRight.isHidden = true
            
        case .completed:
            cell.myView.backgroundColor = UIColor(red: 21/255, green: 28/255, blue: 37/255, alpha: 1)
            cell.myImageView.image = UIImage(named: "checked")
            cell.myImageViewRight.isHidden = false
            cell.myLabelRight.isHidden = false
            
            
            switch  tasks[indexPath.section].tasks[indexPath.row].priority{
            case 1:
                cell.myLabelRight.text = "+8"
            case 2:
                cell.myLabelRight.text = "+13"
            default:
                cell.myLabelRight.text = "+18"
            }
        }

        if tasks[indexPath.section].tasks[indexPath.row].status == "active"{
            let attrString = NSAttributedString(string: tasks[indexPath.section].tasks[indexPath.row].title, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.patternDot.rawValue])
            cell.myLabel.attributedText = attrString
            cell.myLabel.textColor = .white
            cell.descriptionLabel.textColor = UIColor(red: 204/255, green: 222/255, blue: 222/255, alpha: 1)
        }else{
            let attrString = NSAttributedString(string: tasks[indexPath.section].tasks[indexPath.row].title, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.myLabel.attributedText = attrString
            cell.myLabel.textColor = UIColor(red: 68/255, green: 73/255, blue: 81/255, alpha: 1)
            cell.descriptionLabel.textColor = UIColor(red: 68/255, green: 73/255, blue: 81/255, alpha: 1)
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
//MARK: - MyViewCellDelegate
extension TasksViewController : MyViewCellDelegate{
    func checkTapped(cell: MyViewCell) {
        guard let indexPath = taskTableView.indexPath(for: cell) else { return }
        let task = tasks[indexPath.section].tasks[indexPath.row]
        let priority = tasks[indexPath.section].tasks[indexPath.row].priority
        //adding score
        guard let userID = Auth.auth().currentUser?.uid else { return }
        switch priority {
        case 1:
            score += 8
        case 2:
            score += 13
        default:
            score += 18
        }

        db.collection(K.Fstore.Users)
            .document(userID)
            .setData([K.Fstore.scoreField : score],  merge: true) { (error) in
                if let e = error {
                    print("issue saving data \(e)")
                }
        }
        //adding to completed list
        db.collection(K.Fstore.Users)
            .document(task.user)
            .collection(K.Fstore.completedTasks)
            .document(task.taskID)
            .setData([K.Fstore.titleField : task.title, K.Fstore.userField : task.user, K.Fstore.descriptionField : task.description, K.Fstore.priorityField : task.priority, K.Fstore.taskID : task.taskID, K.Fstore.status : "completed"]) { (error) in
            if let e = error{
                print("issue saving data \(e)")
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
            }
        }
        taskTableView.reloadData()
    }
}
//MARK: - LogOutDelegate
extension TasksViewController : LogOutDelegate {
    func sendName(name: String) {
        userNameLabel.text = name
    }
}
