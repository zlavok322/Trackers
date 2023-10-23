import UIKit

protocol ScheduleCellDelegate {
    func didWeekDayIsOnChanged(scheduleElement: ScheduleElement)
}

final class ScheduleTableViewCell: UITableViewCell {
    static let identifier = "ScheduleTableViewCell"
    
    var delegate: ScheduleCellDelegate? = nil
    
    private var scheduleElement: ScheduleElement? = nil
    
    let dayName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .colorStyles(.blueYP)
        daySwitch.isEnabled = true
        
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        return daySwitch
    }()
    
    func configCell(for element: ScheduleElement) {
        addSubview(dayName)
        addSubview(daySwitch)
        
        self.selectionStyle = .none
        
        scheduleElement = element
        
        dayName.text = element.weekDay.getName()
        
        daySwitch.isOn = element.isChoosen
        daySwitch.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        
        setContstraints()
    }
    
    @objc private func switchDidChange(_ sender: UISwitch!) {
        scheduleElement?.isChoosen = sender.isOn
        guard let scheduleElement = scheduleElement else { return }
        delegate?.didWeekDayIsOnChanged(scheduleElement: scheduleElement)
    }
    
    private func setContstraints() {
        NSLayoutConstraint.activate([
            dayName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            dayName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            daySwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            daySwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
