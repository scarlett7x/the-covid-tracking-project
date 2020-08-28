//
//  CoronaData.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/23/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import Foundation
import Charts

protocol CoronaDataDelegate {
    func saveRegionToModel(data: String)
    func saveTime1ToModel(data: Int)
    func saveTime2ToModel(data: Int)
    func saveTypeToModel(data: String)
}

struct coronaElement: Decodable {
    let date: Int
    let positive: Int
    let positiveIncrease: Int
    let death: Int?
    let deathIncrease: Int
    
//    init(json: [String: Any]) {
//        date = json["date"] as? Int ?? -1
//        positive = json["positive"] as? Int ?? -1
//        positiveIncrease = json["positiveIncrease"] as? Int ?? -1
//        death = json["death"] as? Int ?? -1
//        deathIncrease = json["deathIncrease"] as? Int ?? -1
//    }
    
}

class CoronaData: NSObject {
    var dateToCases = [Int: Int]()
    var delegate: CoronaDataDelegate?
    var region: String = "U.S."
    var time1: Int = 20200801
    var time2: Int = 20200820
    var type: String = "death"
    var datesForDisplay: [String] = []
    
    func refresh(completion: @escaping () -> Void) {
        var urlString = "https://api.covidtracking.com/v1/states/\(region)/daily.json"
        if region == "U.S." {
            urlString = "https://api.covidtracking.com/v1/us/daily.json"
        }
        guard let url = URL(string: urlString) else { return }
//        print(urlString)
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let coronaData = data else { return }
            let dataSource = try? JSONDecoder().decode([coronaElement].self, from: coronaData)
//            print(dataSource)
            
            self.dateToCases = [Int: Int]()
            for dataEntry in dataSource! {
                if dataEntry.date >= self.time1 && dataEntry.date <= self.time2 {
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "MM/dd/yy"
//                    let tempDate = String(dataEntry.date)
                    let date = dataEntry.date
                    if (self.type == "positive") {
                        self.dateToCases[date] = dataEntry.positive
                    } else if (self.type == "positiveIncrease") {
                        self.dateToCases[date] = dataEntry.positiveIncrease
                    } else if (self.type == "death") {
                        self.dateToCases[date] = dataEntry.death
                    } else {
                        self.dateToCases[date] = dataEntry.deathIncrease
                    }
//                    print(date, self.type)
                }
            }
            completion()
        }.resume()
    }
    
    func toLineData() -> LineChartData {
        var chartData = [ChartDataEntry]()
        let sortedDates = dateToCases.keys.sorted()
        datesForDisplay = []
        
        for i in 0 ..< sortedDates.count {
            let currDate = sortedDates[i] % 20200000
            datesForDisplay.append("\(currDate / 100)-\(currDate % 100)")
            chartData.append(ChartDataEntry(x: Double(i), y: Double(dateToCases[sortedDates[i]]!)))
        }
//        for ChartDataEntry in chartData {
//            print(ChartDataEntry)
//        }
        let set = LineChartDataSet(entries: chartData, label: "Cases")
        
        set.lineWidth = 1.75
        set.circleRadius = 5.0
        set.circleHoleRadius = 2.5
        set.setColor(.red)
        set.setCircleColor(.red)
        set.highlightColor = .red
        set.drawValuesEnabled = false
        
        return LineChartData(dataSet: set)
    }
    
}
