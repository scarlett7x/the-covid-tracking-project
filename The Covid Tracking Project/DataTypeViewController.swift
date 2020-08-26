//
//  DataTypeViewController.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/21/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import UIKit

protocol DataTypeViewControllerDelegate : NSObjectProtocol {
    func saveType(data: String)
}

class DataTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataTypeArray = ["New Cases", "New Deaths", "Total Cases", "Total Deaths"]
    let fieldArray = ["positiveIncrease", "deathIncrease", "positive", "death"]
    
    @IBOutlet weak var typeTableView: UITableView!
    
    var indexSelected: IndexPath?
    var typeSelected: String?
    weak var delegate: DataTypeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.typeTableView.dataSource = self
        self.typeTableView.delegate = self
        typeTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = typeTableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
         cell.textLabel?.text = dataTypeArray[indexPath.row]
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexSelected != nil {
            let prev = typeTableView.cellForRow(at: indexSelected!)!
            prev.textLabel?.textColor = UIColor.black
        }
        typeTableView.deselectRow(at: indexPath, animated: true)
        let cell = typeTableView.cellForRow(at: indexPath)!
        cell.textLabel?.textColor = UIColor(red: 0.8, green: 0.322, blue: 0.227, alpha: 1)
        indexSelected = typeTableView.indexPath(for: cell)!
        typeSelected = cell.textLabel?.text!
        let fieldSelected = fieldArray[dataTypeArray.firstIndex(of: typeSelected!)!]
        if let delegate = delegate{
            delegate.saveType(data: fieldSelected)
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
