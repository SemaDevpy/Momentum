//
//  MainViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/31/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    
    var tasks : [Task] = []
    
    
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
    }
    
    //MARK: - add a task
    @objc func addTapped(){
        self.navigationController?.present(CreateTaskViewController(), animated: true, completion: nil)
    }
    
    //MARK: - Read of CRUD
    func loadTasks(){
        
        
        guard let user = Auth.auth().currentUser?.phoneNumber else{return}
        
        db.collection(K.Fstore.collectionName).whereField(K.Fstore.userField, isEqualTo: user).addSnapshotListener { (querySnapshot, error) in
            
            self.tasks = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }else{
                if let snapshotDocuments =  querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let title = data[K.Fstore.titleField] as? String, let description = data[K.Fstore.descriptionField] as? String,let priority = data[K.Fstore.priorityField] as? Int{
                            let newTask = Task(title: title, description: description, priority: priority)
                            self.tasks.append(newTask)
                            
                            DispatchQueue.main.async {
                                self.taskTableView.reloadData()
                            }
                            
                            
                        }
                        
                    }
                }
            }
            
        }
    }
}

//MARK: - UITablewViewDelegate, UITablewViewDataSource

extension MainViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyViewCell.identifier, for: indexPath) as! MyViewCell
        cell.backgroundColor = UIColor(named: "myCustomColor")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.myLabel.text = tasks[indexPath.row].title
        cell.descriptionLabel.text = tasks[indexPath.row].description
        
        
        let priority = tasks[indexPath.row].priority
        switch priority{
        case 1:
            cell.myView.layer.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1).cgColor
        case 2:
            cell.myView.layer.backgroundColor = UIColor(red: 0.765, green: 0.659, blue: 0.388, alpha: 1).cgColor
        default:
            cell.myView.layer.backgroundColor = UIColor(red: 0.858, green: 0.39, blue: 0.347, alpha: 1).cgColor
        }
        
        
      
        
        
        
        if selectedIndexPaths.contains(indexPath) {
            cell.setupWith(isCollapsed: true)
        } else {
            cell.setupWith(isCollapsed: false)
        }
        return cell
    }
    
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
    
 
    
    
    
}
