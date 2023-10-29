import UIKit

final class CreateTrackersViewController: UIViewController {
    
    private var viewController: TrackersViewController
    var trackerType: TrackerType?
    
    init(viewController: TrackersViewController){
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let createLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .colorStyles(.blackYP)
        button.layer.cornerRadius = 16
    
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .colorStyles(.blackYP)
        button.layer.cornerRadius = 16
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func createTrackerButtonTapped() {
        let vc = NewTrackerViewController(viewController: self.viewController, trackerType: .tracker)
        present(vc, animated: true)
    }
    
    @objc private func createEventButtonTapped() {
        let vc = NewTrackerViewController(viewController: self.viewController, trackerType: .event)
        present(vc, animated: true)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            createLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            trackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackerButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: trackerButton.bottomAnchor, constant: 16),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
                                    
    }
    
    private func addSubViews() {
        view.addSubview(trackerButton)
        view.addSubview(eventButton)
        view.addSubview(createLabel)
    }
    
    private func setUI() {
        view.backgroundColor = .colorStyles(.whiteYP)
        addSubViews()
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerButton.addTarget(self, action: #selector(createTrackerButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(createEventButtonTapped), for: .touchUpInside)
        setUI()
    }
}
