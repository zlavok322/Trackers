import UIKit

final class NewTrackerViewController: UIViewController {
    
    private let tableCellNames = ["Категория", "Расписание"]
    private var selectedDaysPick = [Week]()
    private var selectedDays: [Week]?
    
    var viewController: TrackersViewController
    
    init(viewController: TrackersViewController) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите название трекера"
        tf.layer.cornerRadius = 16
        tf.backgroundColor = .colorStyles(.backgroundYP)
        tf.font = .systemFont(ofSize: 17, weight: .regular)
        tf.setLeftPaddingPoints(12)
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.colorStyles(.redYP), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.colorStyles(.redYP)?.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .colorStyles(.blackYP)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.register(
            NewTrackerTabelViewCell.self,
            forCellReuseIdentifier: NewTrackerTabelViewCell.identifier
        )
        tableView.separatorStyle = .singleLine
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func configureButtons() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166)
        ])
    }
    
    private func setUi() {
        view.backgroundColor = .colorStyles(.whiteYP)
        addSubviews()
        configureButtons()
        configureTableView()
        setConstraints()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        if textField.text != "" {
            let newCategory = TrackerCategory(
                head: "categorya",
                trackers: [Tracker(
                    id: 0,
                    name: textField.text ?? "",
                    color: .green,
                    emoji: "",
                    schedule: selectedDays ?? [])]
            )
            
            var categories = viewController.categories
            categories.append(newCategory)
            viewController.categories = categories
            
            NotificationCenter.default
                .post(
                    name: TrackersViewController.didChangeCollectionNotification,
                    object: self,
                    userInfo: nil)
            
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
}

extension NewTrackerViewController: ScheduleVCDelegate {
    func selectedWeekDays(weekDaysSelected: [Week]) {
        selectedDays = weekDaysSelected
        tableView.reloadData()
    }
}

//MARK: UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTabelViewCell.identifier, for: indexPath) as? NewTrackerTabelViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = tableCellNames[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.contentView.backgroundColor = .colorStyles(.backgroundYP)
        
        if indexPath.row == 1 {
            let days = selectedDays?.compactMap({ week in
                week.getShortName()
            })
            cell.underLabel.text = days?.joined(separator: ", ")
        }
        return cell
    }
    
    
}

//MARK: UITableViewDelegate
extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated:  true)
        }
    }
}
