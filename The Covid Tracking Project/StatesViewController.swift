//
//  StatesViewController.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/20/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import UIKit


protocol StatesViewControllerDelegate : NSObjectProtocol {
    func saveRegion(data: String)
}

class StatesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let statesArray = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Northern Mariana Islands", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
    
    let abbArray = ["AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MP", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]
    
    let countryArray = ["U.S."]
    
    weak var delegate : StatesViewControllerDelegate?
    var regionIndex = 1
    var regionSelected = "U.S."
    var indexSelected: IndexPath?
    
    @IBOutlet weak var statesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.statesTableView.delegate = self
        self.statesTableView.dataSource = self
        statesTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statesTableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if regionIndex == 0 {
            cell.textLabel?.text = statesArray[indexPath.row]
        } else {
            cell.textLabel?.text = countryArray[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionIndex == 0 {
            return 56
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if regionIndex == 0 {
            if indexSelected != nil {
                let prev = statesTableView.cellForRow(at: indexSelected!)!
                prev.textLabel?.textColor = UIColor.black
            }
            statesTableView.deselectRow(at: indexPath, animated: true)
            let cell = statesTableView.cellForRow(at: indexPath)!
            cell.textLabel?.textColor = UIColor(red: 0.8, green: 0.322, blue: 0.227, alpha: 1)
            indexSelected = statesTableView.indexPath(for: cell)!
            regionSelected = cell.textLabel?.text as! String
            let regionAbb = abbArray[statesArray.firstIndex(of: regionSelected)!] as! String
            if let delegate = delegate{
                delegate.saveRegion(data: regionAbb)
            }
        } else {
            if let delegate = delegate{
                delegate.saveRegion(data: regionSelected)
            }
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
