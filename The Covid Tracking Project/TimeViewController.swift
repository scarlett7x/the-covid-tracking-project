//
//  TimeViewController.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/20/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import UIKit

protocol TimeViewControllerDelegate : NSObjectProtocol {
    func savetime1(data: Int)
    func savetime2(data: Int)
}

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var timeTableView: UITableView!
    var datePickerIndexPath: IndexPath?
    var time1 = 20200801
    var time2 = 20200820
    weak var delegate : TimeViewControllerDelegate?
    let calendar = Calendar.current
    
    var dateFormatter = DateFormatter()
    func setDateFormatter() { // called in viewDidLoad()
        dateFormatter.dateStyle = DateFormatter.Style.short
    }
    
    var events = [Event]()
    func createEvents() { // called in viewDidLoad()
        let month1 = (time1 - 20200000) / 100
        let day1 = time1 % 100
        let month2 = (time2 - 20200000) / 100
        let day2 = time2 % 100
        let event1 = Event(title: "Start Date", time: dateFormatter.date(from: "\(month1)/\(day1)/20")!)
        let event2 = Event(title: "End Date", time: dateFormatter.date(from: "\(month2)/\(day2)/20")!)
        
        events.append(event1)
        events.append(event2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = events.count
        if datePickerIndexPath != nil {
            rows += 1
        }
        return rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            cell = timeTableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
            let datePicker = cell.viewWithTag(1) as! UIDatePicker // set the tag of Date Picker to be 1 in the Attributes Inspector
            datePicker.alpha = CGFloat(indexPath.row)
            let event = events[indexPath.row - 1]
            datePicker.setDate(event.time, animated: true)
        } else {
            cell = timeTableView.dequeueReusableCell(withIdentifier: "EventCell")!
            let event = events[indexPath.row]
            cell.textLabel!.text = event.title
            cell.detailTextLabel!.text = dateFormatter.string(from: event.time)
        }
        return cell
    }
    
//    When we tap a row, tableView:didSelectRowAtIndexPath: is called. There are three cases:

//    1. There is no date picker shown, we tap a row, then a date picker is shown just under it.
//    2. A date picker is shown, we tap the row just above it, then the date picker is hidden.
//    3. A date picker is shown, we tap a row that is not just above it, then the date picker is hidden and another date picker under the tapped row is shown. And there are two subcases:
//    3.1 the tapped is above the shown date picker
//    3.2 the tapped is under the shown date picker
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timeTableView.beginUpdates()
        if datePickerIndexPath != nil && datePickerIndexPath!.row - 1 == indexPath.row { // case 2
            timeTableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        } else { // case 1、3
            if datePickerIndexPath != nil { // case 3
                timeTableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            }
            datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath)
            timeTableView.insertRows(at: [datePickerIndexPath!], with: .fade)
        }
        timeTableView.deselectRow(at: indexPath, animated: true)
        timeTableView.endUpdates()
    }
    
    func calculateDatePickerIndexPath(indexPathSelected: IndexPath) -> IndexPath {
        if datePickerIndexPath != nil && datePickerIndexPath!.row  < indexPathSelected.row { // case 3.2
            return IndexPath(row: indexPathSelected.row, section: 0)
        } else { // case 1、3.1
            return IndexPath(row: indexPathSelected.row + 1, section: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = tableView.rowHeight
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            let cell = timeTableView.dequeueReusableCell(withIdentifier: "DatePickerCell")!
            rowHeight = cell.frame.height
        }
        return rowHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateFormatter()
        createEvents()
        self.timeTableView.delegate = self
        self.timeTableView.dataSource = self
        timeTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
        if let delegate = delegate{
            delegate.savetime1(data: time1)
        }
        if let delegate = delegate{
            delegate.savetime2(data: time2)
        }
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        let dateToday = Calendar.current.date(from: today)!
        // Add 1 to the day to get tomorrow.
        // Don't worry about month and year wraps, the API handles that.
        let yesterday = DateComponents(year: now.year, month: now.month, day: now.day! - 1)
        sender.maximumDate = Calendar.current.date(from: yesterday)!
        sender.minimumDate = dateFormatter.date(from: "2/1/20")!
        print(sender.alpha)
        if sender.alpha == CGFloat(2) {
            sender.minimumDate = dateFormatter.date(from: (timeTableView.cellForRow(at: IndexPath.init(row: 0, section: 0))?.detailTextLabel!.text)!)!
        }
        let parentIndexPath = NSIndexPath(row: datePickerIndexPath!.row - 1, section: 0)
        // change model
        let event = events[parentIndexPath.row]
        event.time = sender.date
        // change view
        let eventCell = timeTableView.cellForRow(at: parentIndexPath as IndexPath)!
        eventCell.detailTextLabel!.text = dateFormatter.string(from: sender.date)

        var year = calendar.component(.year, from: events[0].time)
        var month = calendar.component(.month, from: events[0].time)
        var day = calendar.component(.day, from: events[0].time)
        time1 = year * 10000 + month * 100 + day
        
        year = calendar.component(.year, from: events[1].time)
        month = calendar.component(.month, from: events[1].time)
        day = calendar.component(.day, from: events[1].time)
        time2 = year * 10000 + month * 100 + day
        
        if let delegate = delegate{
            delegate.savetime1(data: time1)
        }
        if let delegate = delegate{
            delegate.savetime2(data: time2)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
