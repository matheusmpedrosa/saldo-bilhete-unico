//
//  Viagem.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/3/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import Foundation

enum TripType: String {
    case commom = "Comum"
    case valeTransporte = "Vale Transporte"
    
    func getTripType() -> String {
        return self.rawValue
    }
}

enum TripValue: Float64 {
    case commom = 4.30
    case valeTransporte = 3.76
    
    func getTripValue() -> Float64 {
        return self.rawValue
    }
}


class Trip: NSObject, NSCoding {
    var type: String?
    var value: Float64?
    var date: Date?
    
    required init(type: TripType, value: TripValue, date: Date) {
        self.type = type.getTripType()
        self.value = value.getTripValue()
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "type") as? String
        value = aDecoder.decodeObject(forKey: "value") as? Float64
        date = aDecoder.decodeObject(forKey: "date") as? Date
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(date, forKey: "date")
    }
}
