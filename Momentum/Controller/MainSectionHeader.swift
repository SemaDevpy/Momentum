import UIKit

protocol MainSectionHeaderDelegate {
    func didTapBackView()
}

public final class MainSectionHeader: UITableViewHeaderFooterView {
    
    public lazy var titleLabel = makeTitleLabel()
    public lazy var backView = makeBackgroungView()
    public lazy var imageView = makeImageView()
    
    var delegate : MainSectionHeaderDelegate?
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubviews()
        setConstraints()
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        myGesture.numberOfTapsRequired = 1
        myGesture.numberOfTouchesRequired = 1
        
        backView.addGestureRecognizer(myGesture)
        backView.isUserInteractionEnabled = true
    }
    
    
    @objc func gestureFired(_ gesture: UITapGestureRecognizer){
        delegate?.didTapBackView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(text: String) {
        contentView.backgroundColor = UIColor(named: "myCustomColor")
        titleLabel.text = text
    }
    
}

extension MainSectionHeader {
    public func setSubviews() {
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(imageView)
    }
    
    public func setConstraints() {
        let constraints = [
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalToConstant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 6),
            imageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),

            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

private extension MainSectionHeader {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeBackgroungView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Line")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
}
