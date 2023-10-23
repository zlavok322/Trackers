import UIKit

protocol TrackerCellDelegate {
    func doneButtonTapped(cell: TrackerCollectionViewCell, tracker: Tracker)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "trackerCell"
    
    private var tracker: Tracker?
    var count = 0 {
        didSet {
            countLabel.text = "\(count) дней"
        }
    }
    var delegate: TrackerCellDelegate?
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setTitle("+", for: .normal)
        button.backgroundColor = .selectionColorStyles(.selection05)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func configCell(tracker: Tracker, count: Int, isCompleted: Bool) {
        self.tracker = tracker
        self.count = count
        doneButton.backgroundColor = tracker.color
        trackerLabel.text = tracker.name
        isCompleted == true ? buttonCompleted() : buttonNotCompleted()
    }
    
    func buttonNotCompleted() {
        doneButton.alpha = 1
        doneButton.setTitle("+", for: .normal)
        doneButton.setImage(nil, for: .normal)
    }
    
    func buttonCompleted() {
        doneButton.setImage(UIImage(named: "Done"), for: .normal)
        doneButton.setTitle("", for: .normal)
        doneButton.alpha = 0.3
    }
    
    func decreaseCount() {
        count -= 1
    }
    
    func increaseCount() {
        count += 1
    }
    
    private func addSubViews() {
        nameView.addSubview(emojiImageView)
        nameView.addSubview(trackerLabel)
        countView.addSubview(countLabel)
        countView.addSubview(doneButton)
        mainView.addSubview(nameView)
        mainView.addSubview(countView)
        contentView.addSubview(mainView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameView.topAnchor.constraint(equalTo: mainView.topAnchor),
            nameView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            nameView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            nameView.heightAnchor.constraint(equalToConstant: 90),
            
            countView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            countView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            countView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            countView.topAnchor.constraint(equalTo: nameView.bottomAnchor),
            
            emojiImageView.topAnchor.constraint(equalTo: nameView.topAnchor, constant: 12),
            emojiImageView.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 12),
            emojiImageView.heightAnchor.constraint(equalToConstant: 24),
            emojiImageView.widthAnchor.constraint(equalToConstant: 24),
            
            doneButton.trailingAnchor.constraint(equalTo: countView.trailingAnchor, constant: -12),
            doneButton.topAnchor.constraint(equalTo: countView.topAnchor, constant: 8),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            
            trackerLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: -12),
            trackerLabel.topAnchor.constraint(equalTo: nameView.topAnchor, constant: 44),
            
            countLabel.leadingAnchor.constraint(equalTo: countView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: countView.topAnchor, constant: 16),
            countLabel.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: -24),
            countLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -8)
            
        ])
    }
    
    @objc func doneButtonTapped() {
        guard let tracker else { return }
        delegate?.doneButtonTapped(cell: self, tracker: tracker)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        addSubViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
