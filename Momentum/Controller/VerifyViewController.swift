//
//  MainViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/30/21.
//

import UIKit
import Firebase

class VerifyViewController: UIViewController {
    
    let sendCodelabel : UILabel = {
       let label = UILabel()
//       label.frame = CGRect(x: 0, y: 0, width: 235, height: 32)
       label.font = label.font.withSize(14)
       label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
      
        
       return label
    }()
    
    
    let loginLabel : UILabel = {
       let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.font = label.font.withSize(36)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    
    let textFieldNum : UITextField = {
       let textField = UITextField()
        textField.layer.backgroundColor = UIColor(red: 0.172, green: 0.252, blue: 0.342, alpha: 1).cgColor
        textField.layer.cornerRadius = 3
        textField.layer.borderWidth = 0.5
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = textField.font?.withSize(14)
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.keyboardType = UIKeyboardType.phonePad
        
        
        textField.attributedPlaceholder = NSAttributedString(string: "Code",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        
        
        return textField
    }()
    
    
    let myButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1).cgColor
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        return button
    }()
    
    var phoneNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        
        view.addSubview(loginLabel)
        view.addSubview(myButton)
        view.addSubview(textFieldNum)
        view.addSubview(sendCodelabel)
        setupLayout()
        sendCodelabel.text = "We’ve sent a code on your phone number :\(phoneNumber)"
    }
    

    func setupLayout(){
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        
        textFieldNum.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textFieldNum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        textFieldNum.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        textFieldNum.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 109).isActive = true
        

        myButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        myButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        myButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        myButton.topAnchor.constraint(equalTo: textFieldNum.bottomAnchor, constant: 109).isActive = true
        
        
        sendCodelabel.leadingAnchor.constraint(equalTo: textFieldNum.leadingAnchor, constant: 0).isActive = true
        sendCodelabel.trailingAnchor.constraint(equalTo: textFieldNum.trailingAnchor).isActive = true
        sendCodelabel.bottomAnchor.constraint(equalTo: textFieldNum.topAnchor, constant: -8).isActive = true
    }
    
    
    @objc func loginBtnTapped(){
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")else{return}
        guard let code = textFieldNum.text else{return}
        
          let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
          Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
           print(error.localizedDescription)
          } else {
            let vc = MainViewController()
            self.navigationController?.pushViewController(vc, animated: true)
           }
        }
        
        
    }
    
    

}
