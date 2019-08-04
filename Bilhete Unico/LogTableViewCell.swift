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
    
    func setup(with tarifa: String, valor: String){
        self.textLabel?.text = tarifa
        self.detailTextLabel?.text = valor
    }

}
