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
    @IBOutlet weak var cleanAllData: UIBarButtonItem!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cardIDLabel: UILabel!
    @IBOutlet weak var editBalanceButton: UIBarButtonItem!
    @IBOutlet weak var commomFareBackgroundView: UIView!
    @IBOutlet weak var commomFareButton: UIButton!
    @IBOutlet weak var voucherFareBackgroundView: UIView!
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
        
        setupLayout()
        checkForFirstLoad()
        loadOldTrips()
    }
    
    fileprivate func setupLayout() {
        //Card View
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 12
        
        //TableView
        tableView.backgroundColor = .clear
        
        //Buttons
        let cornerRadius: CGFloat = 8
        
        commomFareButton.layer.cornerRadius = cornerRadius
        commomFareButton.backgroundColor = .clear
        commomFareBackgroundView.backgroundColor = .blue
        
        voucherFareButton.layer.cornerRadius = cornerRadius
        voucherFareButton.backgroundColor = .clear
        voucherFareBackgroundView.backgroundColor = .green
    }
    
    fileprivate func setNewBalance(with newValue: Float64) {
        self.currentBalance = newValue
        self.balanceLabel.text = String(format: "%.2f", self.currentBalance)
        self.defaults.set(self.currentBalance, forKey: "CurrentBalance")
    }
    
    fileprivate func askUserForCurrentBalance() {        showInputDialog(title: "Parece que é sua primeira vez por aqui!", subtitle: "Qual o valor do seu saldo atual?", actionTitle: "Continuar", cancelTitle: "Cancelar", inputPlaceholder: "50,00", inputKeyboardType: .numbersAndPunctuation, cancelHandler: nil) { (input: String?) in
            if let input = input {
                if let convertedInput = Double(input) {
                    let newTrip: Trip = Trip(type: .income, value: convertedInput, date: Date())
                    self.trips.append(newTrip)
                    ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
                    self.setNewBalance(with: convertedInput)
                    self.tableView.reloadData()
                } else {
                    self.presentAlertWithOptions(title: "Valor inválido", message: "Aplique o valor desejado clicando em Editar", style: .alert, options: "Ok", completion: { (input) in
                    })
                    self.setNewBalance(with: 0.0)
                }
            }
        }
    }
    
    fileprivate func checkForFirstLoad() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "FirstLaunch")
        if firstLaunch.isFirstLaunch {
            askUserForCurrentBalance()
        } else {
            setNewBalance(with: defaults.double(forKey: "CurrentBalance"))
        }
    }
    
    fileprivate func loadOldTrips() {
        if let oldTrips = ArchiveUtil.loadTrips() {
            trips = self.orderArray(arrTrips: oldTrips)
        }
    }
    
    fileprivate func orderArray(arrTrips: [Trip]) -> [Trip]{
        let orderedArray = trips.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
        print(orderedArray)
        
        return orderedArray
    }
    
    //MARK: Actions
    @IBAction func addBalance(_ sender: Any) {
        presentAlertWithOptions(title: "Adicionar fundos", message: "Escolha o valor que deseja adicionar", style: .actionSheet, options: "R$ 50,00", "R$ 100,00", "R$ 150,00", "R$ 200,00", "R$ 300,00", "R$ 500,00", "Cancelar") { (input) in
            print("\(input) foram adicionados")
            var balance = self.defaults.double(forKey: "CurrentBalance")
            balance = balance + input
            let newTrip: Trip = Trip(type: .income, value: input, date: Date())
            self.trips.append(newTrip)
            ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
            self.setNewBalance(with: balance)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func cleanAllData(_ sender: Any) {
        presentAlertWithOptions(title: "Apagar dados", message: "Deseja realmente apagar todas as informações?", style: .alert, options: "Cancelar", "Sim, apagar") { (input) in
            if input == 100.0 { //retorno para "Sim, apagar"
                self.setNewBalance(with: 0.0)
                self.trips.removeAll()
                ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func editBalance(_ sender: Any) {
        showInputDialog(title: "Editar saldo", subtitle: "Digite o valor desejado", actionTitle: "Pronto", cancelTitle: "Cancelar", inputPlaceholder: "R$ 50,00", inputKeyboardType: .numbersAndPunctuation, cancelHandler: nil) { (input) in
            if let input = input {
                if let convertedInput = Double(input) {
                    let newTrip: Trip = Trip(type: .edit, value: convertedInput, date: Date())
                    self.trips.append(newTrip)
                    ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
                    self.setNewBalance(with: convertedInput)
                    self.tableView.reloadData()
                } else {
                    self.presentAlertWithOptions(title: "Valor inválido", message: "Aplique o valor desejado clicando em Editar", style: .alert, options: "Ok", completion: { (input) in
                    })
                }
            }
        }
    }
    
    @IBAction func addCommomFare(_ sender: Any) {
        let newTrip: Trip = Trip(type: .commom, value: 4.30, date: Date())
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
        
        if let value = newTrip.value {
            let newBalance = currentBalance - value
            setNewBalance(with: newBalance)
        }
        tableView.reloadData()
    }
    
    @IBAction func addVRFare(_ sender: Any) {
        let newTrip: Trip = Trip(type: .valeTransporte, value: 3.76, date: Date())
        
        trips.append(newTrip)
        ArchiveUtil.saveTrips(trips: self.orderArray(arrTrips: self.trips))
        
        if let value = newTrip.value {
            let newBalance = currentBalance - value
            setNewBalance(with: newBalance)
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formater: DateFormatter = DateFormatter()
        formater.dateFormat = "dd/MM"

        if trips.count > 0 {
            if let date = trips.first?.date {
                let result = formater.string(from: date)
                return result
            }
        }
        
        return ""
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
