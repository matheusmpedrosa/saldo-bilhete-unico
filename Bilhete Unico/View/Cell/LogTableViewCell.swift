//
//  LogTableViewCell.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(trip: Trip){
        self.textLabel?.text = trip.type
        if let tripValue = trip.value {
            switch trip.type {
            case "Comum":
                self.detailTextLabel?.text = "- R$ " + tripValue.description
                self.imageView?.image = #imageLiteral(resourceName: "outcome")
            case "Vale Transporte":
                self.detailTextLabel?.text = "- R$ " + tripValue.description
                self.imageView?.image = #imageLiteral(resourceName: "outcome")
            case "Depósito":
                self.detailTextLabel?.text = "+ R$ " + tripValue.description
                self.imageView?.image = #imageLiteral(resourceName: "income")
            case "Saldo alterado":
                self.detailTextLabel?.text = "R$ " + tripValue.description
                self.imageView?.image = #imageLiteral(resourceName: "edit")
            default:
                self.imageView?.image = nil
            }
        }
        
    }

}
