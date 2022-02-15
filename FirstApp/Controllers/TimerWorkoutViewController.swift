//
//  TimerViewController.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 26.01.2022.
//

import UIKit

class TimerWorkoutViewController: UIViewController {
    
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
    
    private let timertWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1:35"
        label.font = .robotoBold48()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel = UILabel(text: "detailsLabel")
    private var numberOfSet = 0
    
    private let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .specialGreen
        button.setTitle("FINISH", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints2()
        setWorkoutParameters()
        setDelegates()
        addTaps()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircular()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    private func setDelegates() {
        timerWorkoutParametersView.cellNextSetDelegate2 = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(timertWorkoutImageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(timerWorkoutParametersView)
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
        timer.invalidate()
    }
    
    private func setWorkoutParameters() {
        timerWorkoutParametersView.nameWorkoutLabel2.text = workoutModel.workoutName
        timerWorkoutParametersView.numberOfSetLabel2.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let (min, sec) = workoutModel.workoutTimer.convertSeconds()
        timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
        
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        durationTimer = workoutModel.workoutTimer
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        
        timerWorkoutParametersView.editingButton.isEnabled = false
        timerWorkoutParametersView.nextSetButton.isEnabled = false
        
        if numberOfSet == workoutModel.workoutSets {
            
            alertOk(title: "Error", message: "Finish your workout")
        } else {
        basicAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetLabel2.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            timerWorkoutParametersView.editingButton.isEnabled = true
            timerWorkoutParametersView.nextSetButton.isEnabled = true
        }
        
        let (min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
    }
    
    private let timerWorkoutParametersView = TimerWorkoutParametersView()
    
    var workoutModel = WorkoutModel()
    let customAlert = CustomAlert()
    
    var timer = Timer()
    var durationTimer = 10
    
    let shapeLayer = CAShapeLayer()
}

//MARK: - Animation

extension TimerWorkoutViewController {
    
    private func animationCircular() {
        let center = CGPoint(x:timertWorkoutImageView.frame.width / 2 , y: timertWorkoutImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 135, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        timertWorkoutImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

//MARK- NextSetProtocol

extension TimerWorkoutViewController: NextSetTimerProtocol {
    func editingTimerTapped() {
        customAlert.alertCustom(viewController: self, repsOrTimer: "Timer of set") { [self] sets, timerOfset in
            if sets != "" && timerOfset != "" {
            guard let numberOfSets = Int(sets) else { return }
            guard let numberOfTimer = Int(timerOfset) else { return }
                let (min, sec) = numberOfTimer.convertSeconds()
                timerWorkoutParametersView.numberOfSetLabel2.text = "\(numberOfSets)/\(sets)"
                timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
                timerLabel.text = "\(min): \(sec.setZeroForSeconds())"
                durationTimer = numberOfTimer
                RealmManager.shared.updateSetsTimerWorkoutModel(model: workoutModel, sets: numberOfSets, timer: numberOfTimer)
            }
        }
    }
    
    func nextSetTimerTapped() {
        
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetLabel2.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOk(title: "Error", message: "Finish your workout")
        }
    }
}

//MARK - setConstraints
extension TimerWorkoutViewController {
    
    private func setConstraints2() {
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
            timertWorkoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timertWorkoutImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            timertWorkoutImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            timertWorkoutImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20)
    ])
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: timertWorkoutImageView.leadingAnchor, constant: 80),
            timerLabel.trailingAnchor.constraint(equalTo: timertWorkoutImageView.trailingAnchor, constant: -80),
            timerLabel.centerYAnchor.constraint(equalTo: timertWorkoutImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: timertWorkoutImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            timerWorkoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            timerWorkoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerWorkoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerWorkoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: timerWorkoutParametersView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
