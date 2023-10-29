import UIKit

protocol ScheduleVCDelegate {
    func selectedWeekDays(weekDaysSelected: [Week])
}

final class ScheduleViewController: UIViewController, ScheduleCellDelegate {
    
    private var scheduleList: [ScheduleElement] = []
    private var selectedDays: [Week]?
    
    var delegate: ScheduleVCDelegate? = nil
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Расписание"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.register(
            ScheduleViewCell.self,
            forCellReuseIdentifier: ScheduleViewCell.identifier
        )
        tableView.separatorStyle = .singleLine
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .colorStyles(.blackYP)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureButtons() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func createSheduleList() -> [ScheduleElement] {
            if let selectedDays {
                return Week.allCases.map { dayOfWeek in
                    ScheduleElement(weekDay: dayOfWeek, isChoosen: selectedDays.contains(where: {$0 == dayOfWeek}))
                }
            } else {
                return Week.allCases.map { ScheduleElement(weekDay: $0, isChoosen: false) }
            }
        }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setUI() {
        view.backgroundColor = .colorStyles(.whiteYP)
        addSubViews()
        configureTableView()
        configureButtons()
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleList = createSheduleList()
        setUI()
    }
    
    @objc func doneButtonTapped() {
        let selectDays = scheduleList
            .filter { $0.isChoosen }
            .map { $0.weekDay }
        delegate?.selectedWeekDays(weekDaysSelected: selectDays)
        dismiss(animated: true)
    }
    
    func didWeekDayIsOnChanged(scheduleElement: ScheduleElement) {
        scheduleList = scheduleList.filter { $0.weekDay != scheduleElement.weekDay }
        scheduleList.append(scheduleElement)
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleViewCell.identifier, for: indexPath)
        guard let selectedDaysCell = cell as? ScheduleViewCell else { return UITableViewCell() }
        
        let selectedDays = scheduleList[indexPath.row]
        selectedDaysCell.delegate = self
        selectedDaysCell.configCell(for: selectedDays)
        
        selectedDaysCell.contentView.backgroundColor = .colorStyles(.backgroundYP)
        return selectedDaysCell
    }
}
