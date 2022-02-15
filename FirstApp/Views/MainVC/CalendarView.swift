//
//  CalendarView.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 15.01.2022.
//

import UIKit

protocol SelectCollectionViewItemProtocol: AnyObject {
    func selectItem(date: Date)
}

class CalendarView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    private let idCalendarCell = "idCalendarCell"
    
    weak var cellCollectionViewDelegate: SelectCollectionViewItemProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        setDelegates()
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: idCalendarCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = 10
        backgroundColor = .specialGreen
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
    }
    
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
//    private func weekArray() -> [[String]] {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_GB")
//        dateFormatter.dateFormat = "EEEEEE"
//
//        var weekArray: [[String]] = [[],[]]
//        let calendar = Calendar.current
//        let today = Date()
//
//        for i in -6...0 {
//            let date = calendar.date(byAdding: .weekday, value: i, to: today)
//            guard let date = date else { return weekArray }
//            let components = calendar.dateComponents([.day], from: date)
//            weekArray[1].append(String(components.day ?? 0))
//            let weekDay = dateFormatter.string(from: date)
//            weekArray[0].append(String(weekDay))
//        }
//        return weekArray
//    }
    
}


//MARK: - UICollectionViewDataSource

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCalendarCell, for: indexPath) as! CalendarCollectionViewCell
        let dateTimeZone = Date().localDate()
        let weekArray = dateTimeZone.getWeekArray()
        cell.cellConfigure(numberOfDay: weekArray[1][indexPath.item], dayOfWeek: weekArray[0][indexPath.item])
        
        if indexPath.item == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 8,
               height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
}

//MARK: - UICollectionViewDelegate

extension CalendarView: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let calendar = Calendar.current
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let components = calendar.dateComponents([.month, .year], from: Date())
//        guard let month = components.month else { return }
//        guard let year = components.year else { return }
//
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else { return }
//        guard let numberOfDayString = cell.numberOfDayLabel.text else { return }
//        guard let numberOfDay = Int(numberOfDayString) else { return }
//
//        guard let date = formatter.date(from: "\(year)/\(month)/\(numberOfDay) 00:00") else { return }
//
//        cellCollectionViewDelegate?.selectItem(date: date)
        
        let dateTimeZone = Date().localDate()
        
        switch indexPath.item{
        case 0:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 6))
        case 1:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 5))
        case 2:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 4))
        case 3:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 3))
        case 4:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 2))
        case 5:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 1))
            

        default:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 0))
        }
    }
}

//MARK: - SetConstraints

extension CalendarView {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105),
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
      ])
    }
}
