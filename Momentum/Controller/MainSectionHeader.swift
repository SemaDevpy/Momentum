import UIKit

public final class MainSectionHeader: UITableViewHeaderFooterView {
    
    public lazy var titleLabel = makeTitleLabel()
    public lazy var backView = makeBackgroungView()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubviews()
        setConstraints()
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
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
    }
    
    public func setConstraints() {
        let constraints = [
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

private extension MainSectionHeader {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .cyan
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
    
    func makeBackgroungView() -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
}
