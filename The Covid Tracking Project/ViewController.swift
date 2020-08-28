//
//  ViewController.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/19/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import UIKit
import Charts

class DateAxisValueFormatter : NSObject, IAxisValueFormatter {
    var dates = [String]()
    func take(source: [String]) {
        self.dates = source
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let i = Int(value)
        return dates[i % self.dates.count]
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StatesViewControllerDelegate, TimeViewControllerDelegate, DataTypeViewControllerDelegate, CoronaDataDelegate {

    @IBOutlet weak var testLabel: UILabel!
    let options1 = ["State", "Time Range", "Data Type", "Current Projection", "Data FAQ"]
    let options2 = ["Country: U.S.", "Time Range", "Data Type", "Current Projection", "Data FAQ"]
    var segmentSelected = 1
    var regionSelected = "U.S."
    var startTime = 20200801
    var endTime = 20200820
    var dataType = "positiveIncrease"
    var projectionSwicth = false
    @IBOutlet weak var chart: LineChartView!
    var dataModel = CoronaData()
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    @IBAction func CustomSegmentValueChanged(_ sender: CustomSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentSelected = 1
        case 1:
            segmentSelected = 2
            regionSelected = "U.S."
            saveRegionToModel(data: regionSelected)
            dataModel.refresh() {
                self.setupChart()
            }
        default:
            segmentSelected = 1
        }
        self.optionsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveTypeToModel(data: dataType)
        saveTime1ToModel(data: startTime)
        saveTime2ToModel(data: endTime)
        saveRegionToModel(data: regionSelected)
        dataModel.refresh() {
            self.setupChart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "The COVID Tracking Project"
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        
//        dataModel.refresh() {
//            self.setupChart()
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "optionCell")! as UITableViewCell
        
        if segmentSelected == 1 {
            cell.textLabel?.text = options1[indexPath.row]
            if indexPath.row != 3 {
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            } else {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
                switchView.onTintColor = UIColor(red: 0.8, green: 0.322, blue: 0.227, alpha: 1)
            }
        } else {
            cell.textLabel?.text = options2[indexPath.row]
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        projectionSwicth = sender.isOn
//        self.testLabel.text = "\(projectionSwicth)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentSelected == 1 {
            return options1.count
        } else {
            return options2.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionsTableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "mainToStates", sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "mainToTime", sender: self)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "mainToDataType", sender: self)
        } else if indexPath.row == 4 {
            UIApplication.shared.open(URL(string: "https://covidtracking.com/about-data/data-definitions")!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mainToStates") {
            let statesVC = segue.destination as! StatesViewController
            statesVC.regionIndex = segmentSelected - 1
            statesVC.delegate = self
        } else if (segue.identifier == "mainToTime") {
            let timeVC = segue.destination as! TimeViewController
            timeVC.delegate = self
            timeVC.time1 = self.startTime
            timeVC.time2 = self.endTime
        } else if (segue.identifier == "mainToDataType") {
            let dtVC = segue.destination as! DataTypeViewController
            dtVC.delegate = self
        }
    }
    
    func saveRegion(data: String) {
        regionSelected = data
        self.testLabel.text = regionSelected
    }
    
    func savetime1(data: Int) {
        startTime = data
//        self.testLabel.text = "\(startTime)"
    }
    
    func savetime2(data: Int) {
        endTime = data
//        self.testLabel.text = "\(endTime)"
    }
    
    func saveType(data: String) {
        dataType = data
//        self.testLabel.text = dataType
    }
    
    func setupChart() {
        let data = dataModel.toLineData()
        let datesForDisplay = dataModel.datesForDisplay
        chart.data = data
//        print(datesForDisplay)
        let format = DateAxisValueFormatter()
        format.take(source: datesForDisplay)
        chart.xAxis.valueFormatter = format
        chart.xAxis.granularity = 1.0
        
        chart.chartDescription?.enabled = false
            
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        
        chart.legend.enabled = false
            
        chart.leftAxis.enabled = true
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        chart.leftAxis.axisMinimum = 0
            
        chart.rightAxis.enabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.drawGridLinesEnabled = false
            
        chart.animate(xAxisDuration: 2.5)
    }
    
    func saveRegionToModel(data: String) {
        dataModel.region = regionSelected
    }

    func saveTime1ToModel(data: Int) {
        dataModel.time1 = startTime
    }

    func saveTime2ToModel(data: Int) {
        dataModel.time2 = endTime
    }

    func saveTypeToModel(data: String) {
        dataModel.type = dataType
    }
    
}

