//
//  ViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/30/21.
//

import UIKit
import FirebaseAuth
import InputMask

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
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
        textField.attributedPlaceholder = NSAttributedString(string: "+996 000 00 00 00",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    
    let myButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.165, green: 0.576, blue: 0.576, alpha: 1).cgColor
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var maskDelegate = MaskedTextFieldDelegate(primaryFormat: "+996 [000] [00] [00] [00]")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        textFieldNum.delegate = maskDelegate
        view.addSubview(loginLabel)
        view.addSubview(textFieldNum)
        view.addSubview(myButton)
        setupLayout()
    }

    
    func setupLayout(){
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        textFieldNum.widthAnchor.constraint(equalToConstant: 320).isActive = true
        textFieldNum.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textFieldNum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        textFieldNum.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        textFieldNum.topAnchor.constraint(equalTo: view.topAnchor, constant: 537).isActive = true
        
        myButton.widthAnchor.constraint(equalToConstant: 320).isActive = true
        myButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        myButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        myButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        myButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 696).isActive = true
        
    }
    

    
    
    
    @objc func buttonTapped(){
        guard let saveNumber = textFieldNum.text else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(saveNumber, uiDelegate: self) { (verificationID, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
            let rootVC = VerifyViewController()
            let navVC = UINavigationController(rootViewController: rootVC)
            navVC.navigationController?.navigationBar.isHidden = true
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    
}


extension LoginViewController: AuthUIDelegate {
    
}
