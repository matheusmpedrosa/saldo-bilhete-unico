//
//  Viagem.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import Foundation

class Trip: NSObject {
    var type: String?
    var value: Double?
    var date: Date?
    
    init(type: String, value: Double, date: Date) {
        self.type = type
        self.value = value
        self.date = date
    }
    
}
