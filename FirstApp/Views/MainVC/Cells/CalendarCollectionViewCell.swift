//
//  CalendarCollectionViewCell.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 15.01.2022.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private let dayOfWeakLabel: UILabel = {
        let label = UILabel()
        label.text = "We"
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfDayLabel: UILabel = {
        let label = UILabel()
        label.text = "14"
        label.font = .robotoBold20()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        
        didSet {
            if self.isSelected {
                backgroundColor = .specialYellow
                layer.cornerRadius = 10
                dayOfWeakLabel.textColor = .specialBlack
                numberOfDayLabel.textColor = .specialDarkGreen
            } else {
                backgroundColor = .specialGreen
                dayOfWeakLabel.textColor = .white
                numberOfDayLabel.textColor = .white
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(dayOfWeakLabel)
        addSubview(numberOfDayLabel)
    }
    
    func cellConfigure(numberOfDay: String, dayOfWeek: String) {
        numberOfDayLabel.text = numberOfDay
        dayOfWeakLabel.text = dayOfWeek
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dayOfWeakLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeakLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
        ])
        NSLayoutConstraint.activate([
            numberOfDayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfDayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
}
