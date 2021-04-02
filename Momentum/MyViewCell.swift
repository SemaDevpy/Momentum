//
//  MyViewCell.swift
//  Momentum
//
//  Created by Syimyk on 4/1/21.
//

import UIKit

class MyViewCell: UITableViewCell {
    
    static let identifier = "MyViewCell"
    
    
    
    let myView : UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.859, green: 0.388, blue: 0.345, alpha: 1).cgColor
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World!"
        label.font = .systemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //---contentView
    //----------4
    //------16 view 16
    //----------4
    
    //---contentView
    //----------0
    //------16 view 16
    //----------8

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myView)
        contentView.addSubview(myLabel)
        
        
        //constraints
        let constraints = [
            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            myLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            myLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
    
    
}
