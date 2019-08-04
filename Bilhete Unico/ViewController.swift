//
//  ViewController.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var tarifaComumButton: UIButton!
    @IBOutlet weak var tarifaValeTransporteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Bilhete Único"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let cornerRadius: CGFloat = 4
        let borderWidth: CGFloat = 1.5
        let borderColor: CGColor = self.view.tintColor.cgColor
        
        self.tarifaComumButton.layer.cornerRadius = cornerRadius
        self.tarifaComumButton.layer.borderWidth = borderWidth
        self.tarifaComumButton.layer.borderColor = borderColor
        
        self.tarifaValeTransporteButton.layer.cornerRadius = cornerRadius
        self.tarifaValeTransporteButton.layer.borderWidth = borderWidth
        self.tarifaValeTransporteButton.layer.borderColor = borderColor
    }

    @IBAction func adicionarTarifaComum(_ sender: Any) {
        print("+ R$ 4,30")
    }
    
    @IBAction func adicionarTarifaValeTransporte(_ sender: Any) {
        print("+ R$ 3,76")
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let today: Date = Date()
        let formater: DateFormatter = DateFormatter()
        formater.dateFormat = "dd/MM"
        
        let result = formater.string(from: today)
        
        return result
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogTableViewCell
        
        cell.setup(with: "Tarifa Comum", valor: "R$ 4,30")
        
        return cell
    }
    
    
}

