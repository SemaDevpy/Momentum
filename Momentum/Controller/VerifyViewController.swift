//
//  MainViewController.swift
//  Momentum
//
//  Created by Syimyk on 3/30/21.
//

import UIKit
import FirebaseAuth

class VerifyViewController: UIViewController {
    
    
    
    var timer : Timer!
    var count = 20
    var timerCounting = true
    
    var phoneNumber: String = ""
    
    //MARK: - UIElements
    
    
    let resendLabel : UILabel = {
        let label = UILabel()
        //        label.text = "Resend code in 29sec"
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let noCodeLabel : UILabel = {
        let label = UILabel()
        label.text = "Didn’t get the code?"
        label.alpha = 0.6
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let sendCodelabel : UILabel = {
        let label = UILabel()
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
        textField.text = "123456"
        
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
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        view.layer.backgroundColor = UIColor(red: 0.127, green: 0.181, blue: 0.262, alpha: 1).cgColor
        
        view.addSubview(loginLabel)
        view.addSubview(myButton)
        view.addSubview(textFieldNum)
        view.addSubview(sendCodelabel)
        view.addSubview(noCodeLabel)
        view.addSubview(resendLabel)
        
        sendCodelabel.text = "We’ve sent a code on your phone number :\(phoneNumber)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        //Constraints
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
            
            
            sendCodelabel.leadingAnchor.constraint(equalTo: textFieldNum.leadingAnchor, constant: 0),
            sendCodelabel.trailingAnchor.constraint(equalTo: textFieldNum.trailingAnchor),
            sendCodelabel.bottomAnchor.constraint(equalTo: textFieldNum.topAnchor, constant: -8),
            
            noCodeLabel.leadingAnchor.constraint(equalTo: textFieldNum.leadingAnchor, constant: 0),
            noCodeLabel.trailingAnchor.constraint(equalTo: textFieldNum.trailingAnchor, constant: 0),
            noCodeLabel.topAnchor.constraint(equalTo: textFieldNum.bottomAnchor, constant: 8),
            
            resendLabel.trailingAnchor.constraint(equalTo: textFieldNum.trailingAnchor),
            resendLabel.topAnchor.constraint(equalTo: textFieldNum.bottomAnchor, constant: 8),
        ]
        
        
        NSLayoutConstraint.activate(constraints)
        
        
        
        
    }
    
    
    
//MARK: - timerCounter
    @objc func timerCounter(){
        if count != 0{
            count = count - 1
            resendLabel.text = "Resend code in \(count)sec"
        }else{
            count = 20
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: self) { (verificationID, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                UserDefaults.standard.setValue(verificationID, forKey: "authVerificationID")
            }
            
        }
    }
    
    
    
    
    
    
    
    
    //MARK: - Events
    @objc func loginBtnTapped(){
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")else{return}
        guard let code = textFieldNum.text else{return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let alertVC = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
                }
                alertVC.addAction(action)
                self.present(alertVC, animated: true)
            } else {
                self.timer.invalidate()
                let vc = MainViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
//                self.timer.invalidate()
//                let vc = MainViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}
//MARK: - AuthUIDelegate
extension VerifyViewController: AuthUIDelegate {
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        timer.invalidate()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    
}
