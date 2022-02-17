//
//  ViewController.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 14.01.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Alexander"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.titleLabel?.font = .robotoMedium12()
        button.tintColor = .specialDarkGreen
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 20,
                                              bottom: 15,
                                              right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 50,
                                              left: -40,
                                              bottom: 0,
                                              right: 0)
        button.setImage(UIImage(named: "addWorkout"), for: .normal)
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    private let weatherView = WeatherView()
    
    private let calendarView = CalendarView()
    
    private let idWorkoutTableViewCell = "idWorkoutTableViewCell"
    
    private let workoutTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "Workout today"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label .translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableview: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.bounces = true
        //tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noWorkout")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableview.reloadData()
        setupUserParameters()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        
        setupViews()
        setConstraints()
        setDelegate()
        setupUserParameters()
        getWorkouts(date: Date().localDate())
        getWeather()
        tableview.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkoutTableViewCell)
    }
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>!
    private var userArray: Results<UserModel>!
    
    private func setDelegate() {
        tableview.delegate = self
        tableview.dataSource = self
        calendarView.cellCollectionViewDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableview)
        view.addSubview(noWorkoutImageView)
    }
    
    @objc private func addWorkoutButtonTapped() {
        let newViewController = NewWorkoutViewController()
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true)
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + userArray[0].userSecondName
        
            guard let data = userArray[0].userImage else { return }
            guard let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
        }
    }
    
    private func getWorkouts(date: Date) {

        let dateTimeZone = date.localDate()
        let weekday = dateTimeZone.getWeekDayNumber()
        let dateStart = dateTimeZone.starAndDate().0
        let dateEnd = dateTimeZone.starAndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnrepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnrepeat])

        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        checkWorkoutsToday()
        tableview.reloadData()
    }
    
    private func checkWorkoutsToday() {
        if workoutArray.count == 0 {
            tableview.isHidden = true
            noWorkoutImageView.isHidden = false
        } else {
            tableview.isHidden = false
            noWorkoutImageView.isHidden = true
            tableview.reloadData()
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] model, error in
            guard let self = self else { return }
            if error == nil {
                guard let model = model else { return }
                self.weatherView.weatherStatusLabel.text = "\(model.currently.iconLocal) \(model.currently.temperatureCelcius)°С"
                self.weatherView.weatherDescriptionLabel.text = model.currently.description
                
                guard let imageIcon = model.currently.icon else { return }
                self.weatherView.weatherImage.image = UIImage(named: imageIcon)
            } else {
                self.alertOk(title: "Error", message: "No data weather")
            }
        }
    }
    
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if onBoardingWasViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: false)
        }
    }
}

//MARK: - StartWorkoutProtocol

extension MainViewController: StartWorkoutProtocol {
    func startButtonTapped(model: WorkoutModel) {
        
        if model.workoutTimer == 0 {
            let startViewController = RepsWorkoutViewController()
            startViewController.modalPresentationStyle = .fullScreen
            startViewController.workoutModel = model
            present(startViewController, animated: true)
        } else {
            let timerWorkoutViewController = TimerWorkoutViewController()
            timerWorkoutViewController.modalPresentationStyle = .fullScreen
            timerWorkoutViewController.workoutModel = model
            present(timerWorkoutViewController, animated: true)
        }
    }
}

//MARK: - SelectCollectionViewItemProtocol

extension MainViewController: SelectCollectionViewItemProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date)
    }

}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idWorkoutTableViewCell, for: indexPath) as! WorkoutTableViewCell
        let model = workoutArray[indexPath.row]
        cell.cellConfigure(model: model)
        cell.cellStartWorkoutDelegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { _ , _ , _ in
            let deleteModel = self.workoutArray[indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            tableView.reloadData()
        }
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: - Set Constraints

extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            noWorkoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noWorkoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noWorkoutImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0)
        ])
    }
}

extension UIViewController: UIAdaptivePresentationControllerDelegate {
        public func presentationControllerDidDismiss( _ presentationController: UIPresentationController) {
                viewWillAppear(true)
        }
    }

