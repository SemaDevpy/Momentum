//
//  MainViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/31/21.
//

import UIKit

class MainViewController: UIViewController {
    
//MARK: - UIElements
    let addButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add a Task", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.backgroundColor = UIColor(red: 0.771, green: 0.53, blue: 0.247, alpha: 1).cgColor
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        
        button.translatesAutoresizingMaskIntoConstraints = false
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
        tableView.rowHeight = 50
        tableView.layer.backgroundColor = UIColor(red: 0.107, green: 0.149, blue: 0.213, alpha: 1).cgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        view.addSubview(userTextfield)
        view.addSubview(taskTableView)
        view.addSubview(addButton)
        setupLayout()
    }
    

    //MARK: - setupLayout
    
    func setupLayout(){
        userTextfield.heightAnchor.constraint(equalToConstant: 53).isActive = true
        userTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        userTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        userTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        taskTableView.topAnchor.constraint(equalTo: userTextfield.bottomAnchor, constant: 16).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        taskTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8).isActive = true
        
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
  

}


//MARK: - UITablewViewDelegate, UITablewViewDataSource

extension MainViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    

    
}
