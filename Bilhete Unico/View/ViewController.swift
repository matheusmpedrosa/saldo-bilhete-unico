//
//  ViewController.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var commomFareButton: UIButton!
    @IBOutlet weak var voucherFareButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }

    let defaults = UserDefaults.standard
    var currentBalance: Float64 = Float64()
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oldTrips = ArchiveUtil.loadTrips() {
            trips = oldTrips
        }
        
        setupLayout()
        
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
        if firstLaunch.isFirstLaunch {
            //change currentBalance to your actual current balance
            //alert goes here
            currentBalance = 23.58
            defaults.set(currentBalance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        } else {
            currentBalance = defaults.double(forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
        
    }
    
    fileprivate func setupLayout() {
        //View
        self.title = "Bilhete Único"
        
        //Buttons
        let cornerRadius: CGFloat = 4
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = self.view.tintColor.cgColor
        
        self.commomFareButton.layer.cornerRadius = cornerRadius
        self.commomFareButton.layer.borderWidth = borderWidth
        self.commomFareButton.layer.borderColor = borderColor
        
        self.voucherFareButton.layer.cornerRadius = cornerRadius
        self.voucherFareButton.layer.borderWidth = borderWidth
        self.voucherFareButton.layer.borderColor = borderColor
    }

    @IBAction func addCommomFare(_ sender: Any) {
        let today: Date = Date()
        let value: Float64 = 4.30
        let newTrip: Trip = Trip(type: "Comum", value: value, date: today)
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: trips)
//        defaults.set(trips, forKey: "TripsArray")
        
        if let value = newTrip.value {
            currentBalance = currentBalance - value
            defaults.set(currentBalance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
        tableView.reloadData()
    }
    
    @IBAction func addVRFare(_ sender: Any) {
        let today: Date = Date()
        let value: Float64 = 3.76
        let newTrip: Trip = Trip(type: "Vale Transporte", value: value, date: today)
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: trips)
//        defaults.set(trips, forKey: "TripsArray")
        
        if let value = newTrip.value {
            currentBalance = currentBalance - value
            defaults.set(currentBalance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date: Date = Date()
        let formater: DateFormatter = DateFormatter()
        formater.dateFormat = "dd/MM"
        
        let result = formater.string(from: date)
        
        return result
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfTrips = ArchiveUtil.loadTrips()?.count {
            return numberOfTrips
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogTableViewCell
        
        if let archievedTrips = ArchiveUtil.loadTrips() {
            cell.setup(trip: archievedTrips[indexPath.row])
        }
        
        return cell
    }
}

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
