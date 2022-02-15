//
//  RepsSetsAndButtonsView2.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 26.01.2022.
//

import UIKit

protocol NextSetTimerProtocol: AnyObject {
    func nextSetTimerTapped()
    func editingTimerTapped()
}

class TimerWorkoutParametersView: UIView {
    
    let nameWorkoutLabel2: UILabel = {
        let label = UILabel()
        label.text = "Squats"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsLabel2: UILabel = {
        let label = UILabel()
        label.text = "Sets"
        label.font = .robotoMedium18()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfSetLabel2: UILabel = {
        let label = UILabel()
        label.text = "1/4"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Time of set"
        label.font = .robotoMedium18()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "1 min 30 sec"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium14()
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.setTitle("NEXT SET", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .specialGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialTabBar
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = .specialTabBar
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var setsStackView = UIStackView()
    var timerStackView = UIStackView()
    
    weak var cellNextSetDelegate2: NextSetTimerProtocol?
    
    @objc private func nextSetButtonTapped() {
        cellNextSetDelegate2?.nextSetTimerTapped()
    }
    
    @objc private func editingButtonTapped() {
        cellNextSetDelegate2?.editingTimerTapped()
    }
     
    private func setupViews() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameWorkoutLabel2)
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel2,
                                                      numberOfSetLabel2],
                                    axis: .horizontal,
                                    spacing: 10)
        setsStackView.distribution = .equalCentering
        addSubview(setsStackView)
        addSubview(lineView)
        
        timerStackView = UIStackView(arrangedSubviews: [timerLabel,
                                                      numberOfTimerLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        
        timerStackView.distribution = .equalCentering
        addSubview(timerStackView)
        addSubview(lineView1)
        addSubview(editingButton)
        addSubview(nextSetButton)
     }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameWorkoutLabel2.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameWorkoutLabel2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameWorkoutLabel2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: nameWorkoutLabel2.bottomAnchor, constant: 10),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            setsStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 2),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            timerStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            timerStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        NSLayoutConstraint.activate([
            lineView1.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 2),
            lineView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            lineView1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            lineView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            editingButton.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            editingButton.heightAnchor.constraint(equalToConstant: 20),
            editingButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 10),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextSetButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
}
