//
//  Weather.swift
//  Weather
//
//  Created by DKS_mac on 2019/11/10.
//  Copyright © 2019 dks. All rights reserved.
//

import Foundation

class Weather {
    var temp = 0
    var city = ""
    var condition = 0
    
    // 类型后直接加上花括号定义计算属性
    var icon: String {
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        default :
            return "dunno"
        }
    }
}
