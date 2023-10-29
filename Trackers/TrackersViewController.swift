import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: Properties
    private var trackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
   private let searchTextField: UISearchBar = {
        let searchTF = UISearchBar()
        searchTF.layer.cornerRadius = 10
        searchTF.searchBarStyle = .minimal
        searchTF.placeholder = "Поиск"
        
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        return searchTF
    }()
    
    private let trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collectionView.register(
            HeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderSupplementaryView.identifier
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyTrackersView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyTrackers")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyTrackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var visibleCategories: [TrackerCategory] = []
    private let params: GeometricParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    static let didChangeCollectionNotification = Notification.Name(rawValue: "TrackersCollectionDidChange")
    private var trackersCollectionObserver: NSObjectProtocol?
    
    //MARK: Private function
    private func configureCollectionView() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
    }
    
    private func addObserverForCollection() {
        trackersCollectionObserver = NotificationCenter.default
            .addObserver(
                forName: TrackersViewController.didChangeCollectionNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.setVisibleCategories()
                self.trackersCollectionView.reloadData()
            }
    }
    
    private func addSubViews() {
        view.addSubview(trackerLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        view.addSubview(trackersCollectionView)
        view.addSubview(emptyTrackersView)
        emptyTrackersView.addArrangedSubview(emptyImageView)
        emptyTrackersView.addArrangedSubview(emptyTrackerLabel)
        
    }
    
    private func setBarButtonItems() {
        let createTrackerButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(tapCreateButton))
        navigationItem.leftBarButtonItem = createTrackerButton
        createTrackerButton.tintColor = .colorStyles(.blackYP)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            searchTextField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyTrackersView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTrackersView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func emptyTrackers() {
        if visibleCategories.isEmpty {
            emptyTrackersView.isHidden = false
        } else {
            emptyTrackersView.isHidden = true
        }
    }
    
    private func setVisibleCategories() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
         
        visibleCategories = categories.filter { trackerCategory in
            trackerCategory.trackers.contains { tracker in
                tracker.schedule.contains { week in
                    week.rawValue == weekday
                }
            }
        }
        emptyTrackers()
        trackersCollectionView.reloadData()
    }
    
    private func setUI() {
        datePicker.addTarget(self, action: #selector(datePickerChange(_:)), for: .valueChanged)
        configureCollectionView()
        addSubViews()
        setConstraints()
        setBarButtonItems()
    }
    
    //MARK: objc function
    @objc private func tapCreateButton() {
        let viewController = CreateTrackersViewController(viewController: self)
        viewController.modalPresentationStyle = .automatic
        present(viewController, animated: true)
    }
    
    @objc private func datePickerChange(_ sender: UIDatePicker) {
        currentDate = sender.date
        setVisibleCategories()
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverForCollection()
        setVisibleCategories()
        emptyTrackers()
        setUI()
        searchTextField.delegate = self
    }
}

//MARK: - Extensions

//MARK: UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
}

//MARK: UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return TrackerCollectionViewCell()
        }
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let countCompleted = completedTrackers.filter {
            $0.id == currentTracker.id
        }.count
        
        let isCompleted = completedTrackers.contains(where: {
            $0.id == currentTracker.id && $0.date == currentDate
        })
        
        cell.configCell(tracker: currentTracker, count: countCompleted, emoji: "❤", isCompleted: isCompleted)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.identifier, for: indexPath) as! HeaderSupplementaryView
        header.titleLabel.text = visibleCategories[indexPath.section].head
       
        return header
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        
        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return header.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

//MARK: UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == " " {
            setVisibleCategories()
        } else {
            visibleCategories = visibleCategories.filter({ trackersCategory in
                let filteredTrackers = trackersCategory.trackers.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
                return !filteredTrackers.isEmpty
            }).map { category in
                TrackerCategory(head: category.head, trackers: category.trackers.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil })
            }
        }
        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func doneButtonTapped(cell: TrackerCollectionViewCell, tracker: Tracker) {
        if currentDate > Date() { return }
        
        let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
        
        if completedTrackers.contains(where: { $0.date == currentDate && $0.id == tracker.id }) {
            completedTrackers.remove(trackerRecord)
            cell.buttonNotCompleted()
            cell.decreaseCount()
        } else {
            completedTrackers.insert(trackerRecord)
            cell.buttonCompleted()
            cell.increaseCount()
        }
    }
}
