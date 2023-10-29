import UIKit

struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Week]
}

enum TrackerType {
    case tracker
    case event
}

enum Week: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    func getName() -> String {
        switch self {
        case .sunday:
            return "Воскресенье"
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        }
    }
    
    func getShortName() -> String {
        switch self {
        case .sunday:
            return "Вс"
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        }
    }
}

