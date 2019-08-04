//
//  Viagem.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import Foundation

class Trip: NSObject, NSCoding {
    var type: String?
    var value: Float64?
    var date: Date?
    
    required init(type: String, value: Float64, date: Date) {
        self.type = type
        self.value = value
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "type") as? String
//        value = aDecoder.decodeDouble(forKey: "value")
        value = aDecoder.decodeObject(forKey: "value") as? Float64
        date = aDecoder.decodeObject(forKey: "date") as? Date
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(date, forKey: "date")
    }
    
}
