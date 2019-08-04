//
//  ViewController.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var addBalanceButton: UIBarButtonItem!
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
    let today: Date = Date()
    var trips: [Trip] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        checkForFirstLoad()
        loadOldTrips()
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
    
    fileprivate func checkForFirstLoad() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "FirstLaunch")
        if firstLaunch.isFirstLaunch {
            //change currentBalance to your actual current balance
            //alert goes here
            showInputDialog(title: "Parece que é sua primeira vez por aqui!", subtitle: "Qual o valor do seu saldo atual?", actionTitle: "Continuar", cancelTitle: "Cancelar", inputPlaceholder: "50,00", inputKeyboardType: .numbersAndPunctuation, cancelHandler: nil) { (input: String?) in
                if let input = input {
                    if let convertedInput = Double(input) {
                        self.currentBalance = convertedInput
                        self.balanceLabel.text = String(format: "%.2f", self.currentBalance)
                        self.defaults.set(self.currentBalance, forKey: "CurrentBalance")
                        print("The item is valued at: \(convertedInput)")
                    } else {
                        self.currentBalance = 0.0
                        self.balanceLabel.text = String(format: "%.2f", self.currentBalance)
                        self.defaults.set(self.currentBalance, forKey: "CurrentBalance")
                        print("Not a valid number: \(input)")
                    }
                }
            }
        } else {
            currentBalance = defaults.double(forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
    }
    
    fileprivate func loadOldTrips() {
        if let oldTrips = ArchiveUtil.loadTrips() {
            trips = oldTrips
        }
    }
    
    @IBAction func addMoreBalance(_ sender: Any) {
        presentAlertWithOptions(title: "Adicionar fundos", message: "Escolha o valor que deseja adicionar", style: .actionSheet, options: "R$ 50,00", "R$ 100,00", "Cancelar") { (input) in
            print("\(input) foram adicionados")
            var balance = self.defaults.double(forKey: "CurrentBalance")
            balance = balance + input
            
            self.currentBalance = balance
            self.defaults.set(balance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", self.currentBalance)
        }
    }
    
    //MARK: Actions
    @IBAction func addCommomFare(_ sender: Any) {
        let newTrip: Trip = Trip(type: .commom, value: .commom, date: today)
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: trips)
        
        if let value = newTrip.value {
            currentBalance = currentBalance - value
            defaults.set(currentBalance, forKey: "CurrentBalance")
            self.balanceLabel.text = String(format: "%.2f", currentBalance)
        }
        tableView.reloadData()
    }
    
    @IBAction func addVRFare(_ sender: Any) {
        let newTrip: Trip = Trip(type: .valeTransporte, value: .valeTransporte, date: today)
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: trips)
        
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
        let formater: DateFormatter = DateFormatter()
        formater.dateFormat = "dd/MM"
        
        let result = formater.string(from: today)
        
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
