//
//  UIView+Extension.swift
//  Chat Screen
//
//  Created by Meet Budheliya on 11/03/24.
//


import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var isRound: Bool {
        get {
            return layer.cornerRadius == bounds.height/2 ? true : false
        }
        set {
            layer.cornerRadius = newValue ? bounds.height/2 : layer.cornerRadius
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        get{
            return layer.shadowOffset
        }set{
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
}


//MARK: - UITextview

extension UITextView{
    
    func isTextValid() -> Bool{
        if self.text.isEmpty{
            return false
        }
        
        if self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            return false
        }

        return true
    }
}

//MARK: - UIViewController
extension UIViewController{
    
    // alert message
    func showPopup(message: String){
        self.loadingStop()
        
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let ok_action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok_action)
        self.present(alert, animated: true)
    }
    
    // Loader start and stop
    func loadingStart(){
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func loadingStop(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

extension String{
    
    func formattedDate() -> String {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
        if let date = date_formatter.date(from: self){
            if Calendar.current.isDateInToday(date) {
                return "Today"
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday"
            } else {
                date_formatter.dateFormat = "dd MMM yyyy"
                return date_formatter.string(from: date)
            }
        }else{
            return ""
        }
    }
}
