//
//  MyViewCell.swift
//  Momentum
//
//  Created by Syimyk on 4/1/21.
//

import UIKit

class MyViewCell: UITableViewCell {
    
    let mainVC = MainViewController()
    
    static let identifier = "MyViewCell"
    
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myView : UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.859, green: 0.388, blue: 0.345, alpha: 1).cgColor
        view.layer.cornerRadius = 3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
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
        contentView.addSubview(myImageView)
        
        
        //constraints
        let constraints = [
            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            myLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 14),
            myLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            myImageView.widthAnchor.constraint(equalToConstant: 24),
            myImageView.heightAnchor.constraint(equalToConstant: 24),
            myImageView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 12),
            myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    
    
    
}
