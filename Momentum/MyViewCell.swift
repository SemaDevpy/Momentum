//
//  MyViewCell.swift
//  Momentum
//
//  Created by Syimyk on 4/1/21.
//

import UIKit

protocol MyViewCellDelegate {
    func checkTapped(cell: MyViewCell)
}

class MyViewCell: UITableViewCell {
    
    let mainVC = TasksViewController()
    
    static let identifier = "MyViewCell"
    var delegate : MyViewCellDelegate?
    var isCollapsed: Bool = false
    var descHeight: NSLayoutConstraint?
    var descBottom: NSLayoutConstraint?
    
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "unchecked")
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.802, green: 0.871, blue: 0.871, alpha: 1)
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
        myView.addSubview(myImageView)
        myView.addSubview(myLabel)
        myView.addSubview(descriptionLabel)
        
        //myGesture
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(gestureFired(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        myImageView.addGestureRecognizer(gestureRecognizer)
        myImageView.isUserInteractionEnabled = true
        
        
        //constraints
        let constraints = [
            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            myLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 14),
            myLabel.heightAnchor.constraint(equalToConstant: 24),
            myLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 14),
            myLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -14),
            
            myImageView.widthAnchor.constraint(equalToConstant: 24),
            myImageView.heightAnchor.constraint(equalToConstant: 24),
            myImageView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 12),
            myImageView.topAnchor.constraint(equalTo: myView.topAnchor, constant: 12),
            
            descriptionLabel.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 14),
            descriptionLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 14),
            descriptionLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -14),
        ]
        
        descHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descBottom = descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: myView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate([descBottom!])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func gestureFired(_ gesture: UITapGestureRecognizer){
        delegate?.checkTapped(cell: self)
    }
    
    func setupWith(isCollapsed: Bool) {
        self.isCollapsed = isCollapsed
        
        if isCollapsed {
            descBottom?.constant = -14
            NSLayoutConstraint.deactivate([descHeight!])
        } else {
            descBottom?.constant = 0
            NSLayoutConstraint.activate([descHeight!])
        }
    }
    
    
    
}
