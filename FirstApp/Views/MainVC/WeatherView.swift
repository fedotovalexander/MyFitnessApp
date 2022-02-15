//
//  weatherView.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 17.01.2022.
//

import UIKit

class WeatherView: UIView {

     let weatherStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Солнечно"
        label.textColor = .specialGray
        label.font = .robotoMedium18()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Хорошая погода чтобы позаниматься на улице"
        label.textColor = .specialBrown
        label.font = .robotoMedium14()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "sun")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


     private func setupViews() {
        layer.cornerRadius = 10
        backgroundColor = .white
        addShadowOnView()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(weatherStatusLabel)
        addSubview(weatherImage)
        addSubview(weatherDescriptionLabel)

   }
}
  
extension WeatherView {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImage.heightAnchor.constraint(equalToConstant: 60),
            weatherImage.widthAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            weatherStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherStatusLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: 10),
            weatherStatusLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherStatusLabel.bottomAnchor, constant: 0),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -10),
            weatherDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
