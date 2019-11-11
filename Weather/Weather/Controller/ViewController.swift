//
//  ViewController.swift
//  Weather
//
//  Created by DKS_mac on 2019/11/4.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import CoreLocation         // 获取位置的功能包
import Alamofire            // 网络请求第三方库
import SwiftyJSON           // Swift JSON解析库

class ViewController: UIViewController {

    let locationManager = CLLocationManager()       // 位置管理器
    let weather = Weather()
    let requestURL = "https://api.openweathermap.org/data/2.5/weather"
    let appid = "e72ca729af228beabd5d20e3b7749713"
    
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    // 在视图加载后执行，仅执行一次
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        // 设置位置精度(默认为best，很耗电)，这里使用百米精度即可。精度选项为kcl开头
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // 请求位置
        locationManager.requestLocation()
    }
    
    // 每当视图对用户可见时就执行一次
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)       // override的方法记得先调用父类同名方法
        
        // 使用位置要先在plist中添加对应的description
        // 请求授权在使用APP时使用位置
        locationManager.requestWhenInUseAuthorization()

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectCity" {
            let vc = segue.destination as! SelectCityController
            vc.currentCity = self.weather.city
            
            // 当场景出现时设置delegate
            vc.changeCity = self
        }
        
    }
    

}


// ViewController遵守CLLocationManagerDelegate协议，用于提供更多的位置相关的功能
extension ViewController: CLLocationManagerDelegate {
    
    // 当请求用户位置的时候立刻调用这个方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longtitude = locations[0].coordinate.longitude
       
        let parameters = [
            "lat": "\(latitude)",
            "lon": "\(longtitude)",
            "appid": "\(appid)"
        ]
        
        updateWeather(url: requestURL, paras: parameters)

    }
    
    // 当请求位置发生错误时调用这个方法
    // 该方法必须实现，否则会报SIGABRT异常
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateWeather(url: String, paras: [String: String]){
        // 用responseJSON处理JSON格式的响应，由Alamofire提供
        // 这里的request格式根据api提供者来定，https://是苹果要求的前缀，否则不予支持
        // appid这个参数是必须加的，否则会发生请求无效错误
        Alamofire.request(url, parameters: paras)
            .responseJSON(completionHandler:{
                response in
                if let json = response.result.value {
                    let weatherJSON = JSON(json)    // 用SwiftyJSON处理JSON数据
                    
                    self.updateData(weatherJSON: weatherJSON)
                    
                    self.updateUI(weather: self.weather)
                    
                }
            })
    }
    
    private func updateData(weatherJSON: JSON){
        weather.city = weatherJSON["name"].stringValue
        weather.temp = Int(round(weatherJSON["main", "temp"].doubleValue - 273.15))
        weather.condition = weatherJSON["weather", 0, "id"].intValue
    }
    
    private func updateUI(weather: Weather) {
        cityLabel.text = weather.city
        tempLabel.text = "\(weather.temp)°"
        conditionImage.image = UIImage(named: weather.icon)
    }
    
}

extension ViewController: ChangeCityDelegate {
    func didChangeCity(newCity: String) {
        let paras = [
            "q": "\(newCity)",
            "appid": "\(appid)"
        ]
        updateWeather(url: requestURL, paras: paras)
    }
    
}

