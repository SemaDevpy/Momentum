//
//  CreateTaskViewController.swift
//  Momentum
//
//  Created by Syimyk on 4/2/21.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateTaskViewController: UIViewController {
    
    let db = Firestore.firestore()
    
//MARK: - UIelements
    var stackView = UIStackView()
   
    let createButton : UIButton = {
        let button = UIButton()
        button.setTitle("Create a Task", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1).cgColor
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createBtnTapped), for: .touchUpInside)
        return button
    }()
    
    
    let myLabel : UILabel = {
       let label = UILabel()
        label.text = "Add a title"
        label.font = label.font.withSize(12)
        label.textColor = UIColor(red: 0.741, green: 0.765, blue: 0.78, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextField : UITextField = {
       let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Title",
                                                             attributes: [NSAttributedString.Key.foregroundColor:  UIColor(red: 0.45, green: 0.506, blue: 0.571, alpha: 1)])
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.backgroundColor = UIColor(red: 0.125, green: 0.188, blue: 0.259, alpha: 1).cgColor
        textField.layer.cornerRadius = 5
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    //second
    let myLabel2 : UILabel = {
       let label = UILabel()
        label.text = "Add a description"
        label.font = label.font.withSize(12)
        label.textColor = UIColor(red: 0.741, green: 0.765, blue: 0.78, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextField : UITextField = {
       let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Description",
                                                             attributes: [NSAttributedString.Key.foregroundColor:  UIColor(red: 0.45, green: 0.506, blue: 0.571, alpha: 1)])
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.backgroundColor = UIColor(red: 0.125, green: 0.188, blue: 0.259, alpha: 1).cgColor
        textField.layer.cornerRadius = 5
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
    //third
    let myLabel3 : UILabel = {
       let label = UILabel()
        label.text = "Priority:"
        label.font = label.font.withSize(12)
        label.textColor = UIColor(red: 0.741, green: 0.765, blue: 0.78, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    
   
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.107, green: 0.149, blue: 0.213, alpha: 1).cgColor
        view.addSubview(myLabel)
        view.addSubview(titleTextField)
        view.addSubview(myLabel2)
        view.addSubview(descriptionTextField)
        view.addSubview(myLabel3)
        view.addSubview(createButton)
        configureStackView()
        
        //constraints
        let constraints = [
            myLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            myLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 8),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            myLabel2.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            myLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.topAnchor.constraint(equalTo: myLabel2.bottomAnchor, constant: 8),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            myLabel3.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            myLabel3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 53)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
//MARK: - Configuring the stackView
    func configureStackView(){
        view.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        addButtonsToStackView()
        setStackViewConstraints()
        
    }
   
    
    func addButtonsToStackView(){
        //buttons
        let button1 : UIButton = {
           let button = UIButton()
            button.setTitle("Medium", for: .normal)
            button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1),for: .normal)
            button.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1)
            button.layer.cornerRadius = 3
            button.translatesAutoresizingMaskIntoConstraints = false
           return button
        }()
        
        let button2 : UIButton = {
           let button = UIButton()
            button.setTitle("High", for: .normal)
            button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            button.backgroundColor = UIColor(red: 0.765, green: 0.659, blue: 0.388, alpha: 1)
            button.layer.cornerRadius = 3
           return button
        }()
        
        
        let button3 : UIButton = {
           let button = UIButton()
            button.setTitle("Highest", for: .normal)
            button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1),for: .normal)
            button.backgroundColor = UIColor(red: 0.858, green: 0.39, blue: 0.347, alpha: 1)
            button.layer.cornerRadius = 3
           return button
        }()
        
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        
        
        
        
    }
    
    
    
    func setStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: myLabel3.bottomAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
//MARK: - Create a task event
    //creating task
    @objc func createBtnTapped(){
        if let taskTitle = titleTextField.text, let user = Auth.auth().currentUser?.phoneNumber, let description = descriptionTextField.text{
            db.collection(K.Fstore.collectionName).addDocument(data: [K.Fstore.titleField : taskTitle, K.Fstore.userField : user, K.Fstore.descriptionField : description]) { (error) in
                if let e = error{
                    print("issue saving data \(e)")
                }else{
                    print("success!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
    }
  

}
