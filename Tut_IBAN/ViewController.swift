//
//  ViewController.swift
//  Tut_IBAN
//
//  Created by ruroot on 10/20/18.
//  Copyright © 2018 Eray Alparslan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ibanNoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ibanNoTextField.delegate = self
    }
    
    @IBAction func ibanEditBegun(_ sender: UITextField) {
        if !ibanNoTextField.text!.contains("TR") {
            ibanNoTextField.text = "TR"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if textField == ibanNoTextField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(ibanNo: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(ibanNo: fullString)
            }
            return false
        }
        return true
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func format(ibanNo: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !ibanNo.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: ibanNo).range(of: ibanNo)
        var number = regex.stringByReplacingMatches(in: ibanNo, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 26 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 26)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 11 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{4})(\\d+)", with: " $1 $2", options: .regularExpression, range: range)
        }
            
        else if number.count < 15 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d+)", with: " $1 $2 $3", options: .regularExpression, range: range)
        }
            
        else if number.count < 23 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d{4})(\\d+)", with: " $1 $2 $3 $4", options: .regularExpression, range: range)
        }
            
        else if number.count < 27 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{4})(\\d{4})(\\d{4})(\\d{8})(\\d+)", with: " $1 $2 $3 $4 $5", options: .regularExpression, range: range)
        }
        return number
    }
    
}

