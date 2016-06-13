//
//  PostViewController.swift
//  Project M
//
//  Created by Jacob Lin on 6/9/16.
//  Copyright © 2016 Jacob Lin. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate{
    
    let categoryList = ["","Car","Apartment","Other"]
    var CategoryData=""
    
    @IBOutlet weak var pickerview: UIPickerView!
    @IBOutlet weak var DescriptionInput: UITextView!
    @IBOutlet weak var CategoryInput: UITextField!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var TitleInput: UITextField!
    @IBOutlet weak var ContactInput: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    //UILabel for notification
    //Not necessarily submission confirmation
    @IBOutlet weak var Submitconfirm: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {

        DescriptionInput.textColor = UIColor.lightGrayColor()
        DescriptionInput.text="Please describe details here"
        pickerview.hidden=true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerview.backgroundColor = UIColor.lightGrayColor()
        self.pickerview.delegate = self
        self.pickerview.dataSource = self
        pickerview.showsSelectionIndicator = true
        
        
        
        DescriptionInput.layer.borderColor=UIColor.grayColor().CGColor
        DescriptionInput.layer.borderWidth = 1
        DescriptionInput.layer.cornerRadius=4
        DescriptionInput.delegate = self
        
        CategoryInput.layer.borderColor=UIColor.grayColor().CGColor
        CategoryInput.layer.borderWidth = 1
        CategoryInput.layer.cornerRadius=4
        CategoryInput.delegate = self
        
        
        NameInput.layer.borderColor=UIColor.grayColor().CGColor
        NameInput.layer.borderWidth = 1
        NameInput.layer.cornerRadius=4
        NameInput.delegate = self
        
        TitleInput.layer.borderColor=UIColor.grayColor().CGColor
        TitleInput.layer.borderWidth = 1
        TitleInput.layer.cornerRadius=4
        TitleInput.delegate = self
        
        ContactInput.layer.borderColor=UIColor.grayColor().CGColor
        ContactInput.layer.borderWidth = 1
        ContactInput.layer.cornerRadius=4
        ContactInput.delegate = self
        
        self.view.addSubview(NameInput)
        self.view.addSubview(CategoryInput)
        self.view.addSubview(TitleInput)
        self.view.addSubview(pickerview)
        self.view.addSubview(DescriptionInput)
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let namedata = NameInput.text
        let contactdata = ContactInput.text
        let Titledata = TitleInput.text
        let Descrptiondata = DescriptionInput.text
        
        /*
 
        Data Validation
        check input matches database requirement
         
        */
        
        if namedata == "" || contactdata == "" || Titledata == "" || Descrptiondata == "" || CategoryData == "" || Descrptiondata == "Please describe details here" {
            //Remind user of blanks
            Submitconfirm.text = "You have incomplete cells."
        } else {
        
            var request = NSMutableURLRequest(URL: NSURL(string: "")!)
            if (CategoryData == "Other"){
                request = NSMutableURLRequest(URL: NSURL(string: "http://yichlin.com/PostOther.php")!)
            } else if CategoryData == "Car"{
                request = NSMutableURLRequest(URL: NSURL(string: "http://yichlin.com/PostCar.php")!)
            } else if CategoryData == "Apartment"{
                request = NSMutableURLRequest(URL: NSURL(string: "http://yichlin.com/PostApartment.php")!)
            } else {
                //Unlikely to happen
                request = NSMutableURLRequest(URL: NSURL(string: "http://yichlin.com/PostOther.php")!)
            }
            request.HTTPMethod = "POST"
            print("\n\(CategoryData)\n")
            let postString = "a=\(namedata!)&b=\(contactdata!)&c=\(Titledata!)&d=\(Descrptiondata!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
                if error != nil {
                print("error=\(error)")
                return
                }
            
                print("response = \(response)")
            
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
            task.resume()
            Submitconfirm.text = "Successfully added."
            CategoryInput.text=""
            NameInput.text=""
            DescriptionInput.textColor=UIColor.lightGrayColor()
            DescriptionInput.text = "Please describe details here"
            ContactInput.text=""
            TitleInput.text=""
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == NameInput{
            textField.resignFirstResponder()
            ContactInput.becomeFirstResponder()
            
            return false
        } else {
            textField.resignFirstResponder()
            DescriptionInput.becomeFirstResponder()
            return false
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        Submitconfirm.text = ""
        if textField == CategoryInput {
            DescriptionInput.resignFirstResponder()
            NameInput.resignFirstResponder()
            TitleInput.resignFirstResponder()
            pickerview.becomeFirstResponder()
            pickerview.hidden=false
            textField.inputView = pickerview
            return false
        } else {
            return true
        }
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.becomeFirstResponder()
       
        return true
    
    }
    
    //return key function
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    //在未输入任何内容时 显示提示
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        Submitconfirm.text = ""
        
        if textView.text == "Please describe details here" {
            textView.text = ""
            textView.textColor=UIColor.blackColor()
        }
        return true
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Please describe details here"
            textView.textColor=UIColor.lightGrayColor()
        }
    }
    
    //pickerview setup
    
    //Number of columns
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of rows
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    //setup selection sourse 
    //return [String]
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    //pickerview height
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    //pickerview selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        CategoryData=categoryList[row]
        CategoryInput.text = CategoryData
        pickerview.resignFirstResponder()
        pickerview.hidden = true
    }
    
    //点击空白处退出编辑
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        DescriptionInput.resignFirstResponder()
        NameInput.resignFirstResponder()
        TitleInput.resignFirstResponder()
        pickerview.hidden=true
        pickerview.resignFirstResponder()
        ContactInput.resignFirstResponder()
        
    }
}