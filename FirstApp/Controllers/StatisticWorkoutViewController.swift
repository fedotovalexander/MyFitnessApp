//
//  StatisticViewController.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 21.01.2022.
//

import UIKit
import RealmSwift

struct DifferenceWorkout {
    let name: String
    let lastReps: Int
    let firstReps: Int
}

class StatisticWorkoutViewController: UIViewController {
    
    private let statisticsLabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTICS"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any,
                                                 NSAttributedString.Key.foregroundColor: UIColor.white],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any,
                                                 NSAttributedString.Key.foregroundColor: UIColor.specialGray],
                                                for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let nameTextfield: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let exercisesLabel = UILabel(text: "Exercises")
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let idStaticticTableViewCell = "idStaticticTableViewCell"
    
    let localRealm = try! Realm()
    var workoutArray: Results<WorkoutModel>!
    
    var differenceArray = [DifferenceWorkout]()
    let dateToday = Date().localDate()
    
    private var filteredArray = [DifferenceWorkout]()
    private var isFiltred = false
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        setDelegates()
        setStartScreen()
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        nameTextfield.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(statisticsLabel)
        view.addSubview(segmentedControl)
        view.addSubview(nameTextfield)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: idStaticticTableViewCell)
       
    }
    
    private func setStartScreen() {
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
        
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        } else {
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        }
    }
    
    private func getWorkoutsName() -> [String] {

        var nameArray = [String]()
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutsName()
        
        for name in nameArray {
            
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            
            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else {
                      return
                  }
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            differenceArray.append(differenceWorkout)
        }
    }
    
    private func filtringWorlouts(text: String) {
        
        for workout in differenceArray {
            if workout.name.lowercased().contains(text) {
                filteredArray.append(workout)
            }
        }
        
    }
}

//MARK: - UITextFieldDelegate

extension StatisticWorkoutViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range , in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            filteredArray = [DifferenceWorkout]()
            isFiltred = (updatedText.count > 0 ? true : false)
            filtringWorlouts(text: updatedText)
            tableView.reloadData()
        }
    return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextfield.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isFiltred = false
        differenceArray = [DifferenceWorkout]()
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
        return true
    }
}

//MARK: - UITableViewDataSource

extension StatisticWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltred ? filteredArray.count : differenceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idStaticticTableViewCell, for: indexPath) as! StatisticTableViewCell
        let differenceModel = (isFiltred ? filteredArray[indexPath.row] : differenceArray[indexPath.row])
        cell.cellConfigure(differenceWorkout: differenceModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension StatisticWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
}

//MARK: - setConstraints

extension StatisticWorkoutViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: statisticsLabel.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nameTextfield.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextfield.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            exercisesLabel.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor, constant: 5),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
  }
}
