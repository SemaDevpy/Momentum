//
//  LogOutViewController.swift
//  Momentum
//
//  Created by Sema on 4/9/21.
//

import UIKit
import FirebaseAuth

class LogOutViewController: UIViewController {
    
    
    
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
    
    
    let myTextField : UITextField = {
        let textField = UITextField()
        textField.text = "John Peterson"
        textField.font = textField.font?.withSize(18)
        textField.textColor =  .black
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
    let myView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let myButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Log Out", for: .normal)
        btn.layer.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1).cgColor
        btn.layer.cornerRadius = 3
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Page"
        
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .gray
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(myView)
        view.addSubview(myButton)
        myView.addSubview(myImageView)
        myView.addSubview(myLabel)
        myView.addSubview(myTextField)
        
        
        let constraints = [
            myView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myView.heightAnchor.constraint(equalToConstant: 55),
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            myTextField.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            myTextField.trailingAnchor.constraint(equalTo: myLabel.leadingAnchor, constant: -8),
            myTextField.topAnchor.constraint(equalTo: myView.topAnchor, constant: 16),
            
            myImageView.widthAnchor.constraint(equalToConstant: 20),
            myImageView.heightAnchor.constraint(equalToConstant: 20),
            myImageView.topAnchor.constraint(equalTo: myView.topAnchor, constant: 16),
            myImageView.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -16),
            
            
            myLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 16),
            myLabel.trailingAnchor.constraint(equalTo: myImageView.leadingAnchor, constant: -8),
            
            myButton.heightAnchor.constraint(equalToConstant: 50),
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 150),
            myButton.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    @objc func buttonTapped(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
    
}