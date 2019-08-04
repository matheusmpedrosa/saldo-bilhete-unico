//
//  ViewController.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

final class FirstLaunch {
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(getWasLaunchedBefore: () -> Bool,
         setWasLaunchedBefore: (Bool) -> ()) {
        let wasLaunchedBefore = getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setWasLaunchedBefore(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults, key: String) {
        self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) },
                  setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
    }
}

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
    var currentBalance: Double = Double()
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.any-suggestion.FirstLaunch.WasLaunchedBefore")
        if firstLaunch.isFirstLaunch {
            //change currentBalance to your actual current balance
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
        let newTrip: Trip = Trip(type: "Comum", value: 4.30, date: today)
        
        trips.append(newTrip)
        if let value = newTrip.value {
            currentBalance = currentBalance - value
            defaults.set(currentBalance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
        tableView.reloadData()
    }
    
    @IBAction func addVRFare(_ sender: Any) {
        let today: Date = Date()
        let newTrip: Trip = Trip(type: "Vale Transporte", value: 3.76, date: today)
        
        trips.append(newTrip)
        
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
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogTableViewCell
        
        cell.setup(trip: trips[indexPath.row])
        
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
