//
//  ViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/30/21.
//

import UIKit
import FirebaseAuth
import InputMask

class LoginViewController: UIViewController ,UITextFieldDelegate{
    
    let maxInput = 13
    
    let invalidInputLabel : UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 64, height: 14)
        label.text = "Invalid input"
        label.textColor = UIColor(red: 0.967, green: 0.326, blue: 0.48, alpha: 1)
        label.font = UIFont(name: "Roboto-Light", size: 12)
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = textField.font?.withSize(14)
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.keyboardType = UIKeyboardType.phonePad
        textField.attributedPlaceholder = NSAttributedString(string: "+996 000 00 00 00",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.text = "+996706929120"
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
        invalidInputLabel.isHidden = true
        navigationController?.navigationBar.isHidden = true
        view.addSubview(loginLabel)
        view.addSubview(textFieldNum)
        view.addSubview(myButton)
        view.addSubview(invalidInputLabel)
        

        //constraints
        let constraints = [
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            

            textFieldNum.heightAnchor.constraint(equalToConstant: 50),
            textFieldNum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            textFieldNum.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            textFieldNum.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 109),
            

            myButton.heightAnchor.constraint(equalToConstant: 50),
            myButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            myButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            myButton.topAnchor.constraint(equalTo: textFieldNum.bottomAnchor, constant: 109),
            
            invalidInputLabel.leadingAnchor.constraint(equalTo: textFieldNum.leadingAnchor),
            invalidInputLabel.topAnchor.constraint(equalTo: textFieldNum.bottomAnchor, constant: 8)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
  
    

    
    
    
    @objc func buttonTapped(){
        guard let saveNumber = textFieldNum.text else { return }
        let newString = saveNumber.replacingOccurrences(of: " ", with: "")
        guard newString.count == maxInput else {
            textFieldNum.clearButtonMode = .whileEditing
            invalidInputLabel.isHidden = false
            textFieldNum.layer.borderColor = UIColor(red: 0.965, green: 0.325, blue: 0.478, alpha: 0.8).cgColor
            return
        }
//        PhoneAuthProvider.provider().verifyPhoneNumber(saveNumber, uiDelegate: self) { (verificationID, error) in
//            if let error = error {
//                print("\(error.localizedDescription)")
//                return
//            }
//            UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
//            let rootVC = VerifyViewController()
//            rootVC.phoneNumber = saveNumber
//            self.navigationController?.pushViewController(rootVC, animated: true)
//        }
        
        //code without auth
        let rootVC = VerifyViewController()
        rootVC.phoneNumber = saveNumber
        self.navigationController?.pushViewController(rootVC, animated: true)
        
        
        
        
        
    }
    
    
}


extension LoginViewController: AuthUIDelegate {
    
}



