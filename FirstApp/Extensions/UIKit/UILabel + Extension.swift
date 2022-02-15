//
//  UILabel + Extension.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 29.01.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init()
        
        self.text = text
        self.font = .robotoMedium14()
        self.textColor = .specialLightBrown
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
