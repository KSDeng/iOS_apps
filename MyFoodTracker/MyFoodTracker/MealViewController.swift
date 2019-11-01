//
//  MealViewController.swift
//  MyFoodTracker
//
//  Created by DKS_mac on 2019/10/14.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import os.log

// UITextFieldDelegate协议使Controller可以响应text field的事件
//
class MealViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mealNameTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // 存储新添加的meal
    var meal: Meal?
    
    // 当触发segue时prepare函数中的代码将被执行
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // 确定sender是一个UIBarButtonItem，并且是saveButton
        // 引用的比较用"==="
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // 获取输入控件的值
        let name = mealNameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // 将获取的值赋值给对象成员
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field's user input through delegate callbacks.
        // 这一行为什么要这么写？delegate成员在哪里用到了？
        // 回调？不理解
        mealNameTextField.delegate = self
        
        
        // Set up views of editing an existing meal
        if let meal = meal {
            // 把和控件关联的变量更新之后界面也会随之更新(貌似XCode做完了该部分工作...)
            navigationItem.title = meal.name
            mealNameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    // 当文本域开始编辑时被调用
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 将saveButton设置为不可用
        saveButton.isEnabled = false
    }
    
    // called when 'return' key pressed. return NO to ignore.
    // what's "first responder"?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Call function textFieldShouldReturn")
        textField.resignFirstResponder()
        return false        // return true和return false没区别？
    }
    
    // called when press the "Done" button on the keyborad
    // 真机运行结果发现按"确认"之后键盘并没有缩回去？
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Call function textFieldDidEndEditing")
        updateSaveButtonState()
        // 当场景被置于navigation view内时，navigationItem自动变为内置变量
        // 将navigationItem的标题置为textField的内容，外观比较美观
        navigationItem.title = textField.text
        
    }
    

    
    
    @IBAction func tapPhotoImageView(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
        // How does this line of code works?
        mealNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // 将图片来源限定在图库(而不能现场拍照)
        // 如果想同时允许两种怎么办？
        imagePickerController.sourceType = .photoLibrary
    
        // 这句话的含义与作用？
        imagePickerController.delegate = self
        
        // 以下一行在self(ViewController)上执行(以下摘自文档)
        // The method asks ViewController to present the view controller defined by imagePickerController.
        // Passing true to the animated parameter animates the presentation of the image picker controller. The completion parameter refers to a completion handler, a piece of code that executes after this method completes. Because you don’t need to do anything else, you indicate that you don’t need to execute a completion handler by passing in nil.
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 允许用户选择图片还须实现以下两个方法(在UIImagePickerControllerDelegate中定义)
    
    // 取消图片选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // 当用户选中图片时被调用
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 获取选中的图片
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage else{
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // 将选中的图片设置到image view上
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState(){
        // meal 名字为空时将saveButton设置为不可用
        let text = mealNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // 判断进入当前视图的方式
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode{
            // 用户点击的是添加按钮
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController {
            // 用户直接点击列表中的某个meal进行编辑
            // 这里哪来的navigationController?编辑时未用到navigationController？
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }

    }
    
    
    
}

