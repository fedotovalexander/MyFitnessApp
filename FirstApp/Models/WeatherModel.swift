//
//  WeatherModel.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 12.02.2022.
//

import Foundation

struct WeatherModel: Decodable {
    let currently: Currently
}

struct Currently: Decodable {
    let temperature: Double
    let icon: String?

    var temperatureCelcius: Int {
        return (Int(temperature) - 32) * 5 / 9
   }
    
    var iconLocal: String {
        switch icon {
        case "clear-day" : return "Ясно"
        case "clear-night" : return "Ясная ночь"
        case "rain" : return "Дождь"
        case "snow" : return "Снег"
        case "sleet" : return "Мокрый снег"
        case "wind" : return "Ветренно"
        case "fog" : return "Туман"
        case "cloudy" : return "Облачно"
        case "partly-cloudy-day" : return "Пасмурный день"
        case "partly-cludy-night" : return "Пасмурная ночь"
        default: return "No data"
        }
    }
    
    var description: String {
        switch icon {
        case "sun" : return "Хорошая погода для занятий на улице!"
        case "clear-night" : return "Отдыхай!!"
        case "rain" : return "Не подведи)"
        case "snow" : return "Идеальная погода для тренировки"
        case "sleet" : return "Пора тренить"
        case "wind" : return "Только вперед"
        case "fog" : return "Пора позаниматься"
        case "cloudy" : return "Пора позаниматься"
        case "partly-cloudy-day" : return "Пора позаниматься"
        case "partly-cludy-night" : return "Пора позаниматься"
        default: return "No data"
        }
    }
}
