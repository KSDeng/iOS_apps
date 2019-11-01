//
//  Meal.swift
//  MyFoodTracker
//
//  Created by DKS_mac on 2019/10/20.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import os.log

struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
}

// 为使Meal类能够序列化，其必须是NSObject的子类，并遵循NSCoding协议
class Meal: NSObject, NSCoding {

    var name: String
    var photo: UIImage?
    var rating: Int
    
    // 如何指定到任意的路径？
    // 从文件系统中选择数据存档路径
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // 创建并获取数据存档目录
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("meal")
    
    // failable initializer
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // 用guard语句尽量将每个判断条件分开, 便于后续测试
        guard !name.isEmpty else {
            return nil
        }
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // encode方法决定如何将Meal对象进行存储
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // 该方法决定如何从存储中读取并初始化Meal对象
    // required关键字表示子类中必须实现该方法
    // convenience关键字表示该构造器为secondary initializer，必须调用其它delegate initializer
    // 当调用该型initializer时编译器如何知道要调用哪个？
    required convenience init? (coder aDecoder: NSCoder){
        // 若无法解析对象的name字符串，则直接报错，因为name是必填字段
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for a Meal object.", log: OSLog.default,
                       type: .debug)
                return nil
        }
        
        // 对象用decodeObject方法进行解析后用as?进行Type Casting
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        // 基本类型直接用对应的方法进行解析
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: name, photo: photo, rating: rating)
        
        
    }
    
    
}


