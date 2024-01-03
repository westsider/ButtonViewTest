//
//  Button Store.swift
//  ButtonViewTest
//
//  Created by Warren Hansen on 1/3/24.
//

import SwiftUI

class ButtonStore {
    var lumbarNum: Int
    @State var leftSelected: Bool
    
    enum Axis {
        case Ax, Sg
    }
    
    init(lumbarNum: Int, leftSelected: Bool) {
        self.lumbarNum = lumbarNum
        self.leftSelected = leftSelected
    }
    
    static func clearLumbarStorage() {
        
        // loop through L1-4 on left
        for num in 1...4 {
            let axKeysLeft = ButtonStore(lumbarNum: num, leftSelected: true).axKeys()
            let sgKeysLeft = ButtonStore(lumbarNum: num, leftSelected: true).sgKeys()
            @AppStorage(axKeysLeft)  var axialLeft = 1.0
            @AppStorage(sgKeysLeft)  var sagitalLeft = 1.0
            
            // clear ax and sg
            axialLeft = 0.0
            sagitalLeft = 0.0
        }
        
        // change to right
        for num in 1...4 {
            let axKeysLeft = ButtonStore(lumbarNum: num, leftSelected: false).axKeys()
            let sgKeysLeft = ButtonStore(lumbarNum: num, leftSelected: false).sgKeys()
            @AppStorage(axKeysLeft)  var axialLeft = 1.0
            @AppStorage(sgKeysLeft)  var sagitalLeft = 1.0
            
            // clear ax and sg
            axialLeft = 0.0
            sagitalLeft = 0.0
        }
    }
    
    func setLumbar() -> String {
        let lumbarStr = String(describing: lumbarNum)
        
//        switch lumbarNum {
//        case 1:
//            lumbarStr = String(describing: lumbarNum)
//        case 2:
//            lumbarStr = String(describing: Lumabar.L2)
//        case 3:
//            lumbarStr = String(describing: Lumabar.L3)
//        case 4:
//            lumbarStr = String(describing: Lumabar.L4)
//        default:
//            lumbarStr = String(describing: Lumabar.L1)
//        }
        return lumbarStr
    }
    
    func setSide() -> String {
        var sideStr = ""
       
        switch leftSelected {
        case true:
            sideStr = "Left"
        case false:
            sideStr = "Right"
        }
        return sideStr
    }
    
    func axKeys() -> String {
        let lumbarStr = setLumbar()
        let sideStr = setSide()
        return sideStr + String(describing:Axis.Ax) + lumbarStr
    }
    
    func sgKeys() -> String {
        let lumbarStr = setLumbar()
        let sideStr = setSide()
        return sideStr + String(describing:Axis.Sg) + lumbarStr
    }
}

class Utilities {
    /**
        *Strip Down Bluetooth ID*
         - important: this is designed to make a barcode scanned id match what the RJB devices are transmitting
          by striping out the model number and decimal
         - parameter bluetoothID: The transmitted bluetooth ID.
         - returns: String?
         - version: 1.0
    */
    class func cleanUP(bluetoothID:String)-> String? {
        let strArray = bluetoothID.components(separatedBy: " ")
        guard let nums = strArray.last  else {
            return nil
        }
        return nums.replacingOccurrences(of: ".", with: "")
    }
    
    static func getDoubleFrom(string: String) -> Double {
        var answer = 0.0
    
        var trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.prefix(1) == "+" {
            trimmed = String(trimmed.dropFirst())
        }
       
        
        if let  answer2 = Double(trimmed) {
           // print("got \(string) -> \(answer2)")
            answer = answer2
        }
        
        return answer
    }
    
    static func oneDecimal(fromDouble: Double) -> String {
        
        String(format: "%.01f", fromDouble)
    }
}
