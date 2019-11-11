//
//  SelectCityController.swift
//  Weather
//
//  Created by DKS_mac on 2019/11/11.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

// delegate用于反向传值
protocol ChangeCityDelegate {
    func didChangeCity(newCity: String)
}

class SelectCityController: UIViewController {

    
    var currentCity = ""
    var changeCity: ChangeCityDelegate?
    
    @IBOutlet weak var currentCityLabel: UILabel!
    
    @IBOutlet weak var cityTextInput: UITextField!
    
    @IBAction func changeCity(_ sender: UIButton) {
        changeCity?.didChangeCity(newCity: cityTextInput.text!)
        
        // 销毁当前页面
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCityLabel.text = currentCity

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
