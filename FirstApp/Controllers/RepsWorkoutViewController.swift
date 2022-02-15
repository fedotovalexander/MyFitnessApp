//
//  StartViewController.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 24.01.2022.
//

import UIKit

class RepsWorkoutViewController: UIViewController {
    
    private let startWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "START WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let startWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "startWorkout")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = .robotoMedium14()
        label.textColor = .specialLightBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .specialGreen
        button.setTitle("FINISH", for: .normal)
        button.titleLabel?.font = .robotoBold20()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setWorkoutParameters()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setDelegates() {
        workoutParametersView.cellNextSetDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(startWorkoutImageView)
        view.addSubview(detailsLabel)
        view.addSubview(workoutParametersView)
        view.addSubview(finishButton)
    }
    
    @objc private func finishButtonTapped() {
        
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel, bool: true)
        } else {
            alertOkCancel(title: "Warning", message: "You haven`t finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setWorkoutParameters() {
        workoutParametersView.nameWorkoutLabel.text = workoutModel.workoutName
        workoutParametersView.numberOfSetLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        workoutParametersView.numberOfRepsLabel.text = "\(workoutModel.workoutReps)"
    }
    
    private var numberOfSet = 1
    
    private let workoutParametersView = WorkoutParametersView()
    
    var workoutModel = WorkoutModel()
    let customAlert = CustomAlert()
    
}
//MARK- NextSetProtocol

extension RepsWorkoutViewController: NextSetProtocol {
    func editingTapped() {
        customAlert.alertCustom(viewController: self, repsOrTimer: "Reps") { [self] sets, reps in
            if sets != "" && reps != "" {
            workoutParametersView.numberOfSetLabel.text = "\(numberOfSet)/\(sets)"
            workoutParametersView.numberOfRepsLabel.text = reps
            guard let numberOfSets = Int(sets) else { return }
            guard let numberOfReps = Int(reps) else { return }
            RealmManager.shared.updateSetsRepsWorkoutModel(model: workoutModel, sets: numberOfSets, reps: numberOfReps)
            }
        }
    }
    
    func nextSetTapped() {
        
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersView.numberOfSetLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOk(title: "Error", message: "Finish your workout")
        }
    }
}

//MARK - setConstraints
extension RepsWorkoutViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            startWorkoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startWorkoutImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            startWorkoutImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            startWorkoutImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20)
    ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: startWorkoutImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            workoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            workoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: workoutParametersView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
