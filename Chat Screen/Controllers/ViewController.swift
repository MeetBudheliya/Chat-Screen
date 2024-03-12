//
//  ViewController.swift
//  Chat Screen
//
//  Created by Meet Budheliya on 11/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tbl_chats: UITableView!
    @IBOutlet weak var tv_message: UITextView!
    @IBOutlet weak var switch_user: UISwitch!
    @IBOutlet weak var view_image_container: UIView!
    @IBOutlet weak var img_selected_message: UIImageView!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var con_bottom: NSLayoutConstraint!
    
    //MARK: - Variables
    var messages: [Chat] = []
    var image_path = ""
    let imagePicker =  UIImagePickerController()
    var selected_image = UIImage(){
        didSet{
            if selected_image != UIImage(){
                img_selected_message.image = selected_image
                view_image_container.isHidden = false
            }else{
                view_image_container.isHidden = true
                img_selected_message.image = UIImage(named: "ic_logo")
            }
            tbl_chats.layoutIfNeeded()
        }
    }
    var last_day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSetup()
        
        // textview setup
        tv_message.delegate = self
        tv_message.textColor = .lightGray
        tv_message.text = Keys.chat_placeholder
        tv_message.textContainer.lineBreakMode = .byWordWrapping
        tv_message.textContainer.maximumNumberOfLines = 3
        
        // image message
        view_image_container.isHidden = true
        image_path = ""
        
        // image picker
        imagePicker.delegate = self
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
        self.messages.append(Chat(body: "initial message", senderID: switch_user.isOn ? "1" : "2", receiverID: switch_user.isOn ? "2" : "1", time: date_formatter.string(from: Date()), bodyType: "t", image: ""))
        self.tbl_chats.reloadData()
        
        //loadJson(filename: "Records")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Methods
    func loadJson(filename fileName: String){
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any] {
                    print("JSON: \(json)")
                } else {
                    print("Given JSON is not a valid dictionary object.")
                }
            }
        } catch {
            print(error)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.con_bottom.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.con_bottom.constant = 10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tapOutside(){
        self.tv_message.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    //MARK: - Actions
    @IBAction func BTNCameraAction(_ sender: UIButton) {
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: name, message: "Choose media type to select image", preferredStyle: .actionSheet)
        
        let camera_action = UIAlertAction(title: "Capture", style: .default) { action in
            self.openCamera()
        }
        let photos_action = UIAlertAction(title: "Open Photos", style: .default) { action in
            self.openGallary()
        }
        let cancel_action = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(camera_action)
        alert.addAction(photos_action)
        alert.addAction(cancel_action)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func BTNSendAction(_ sender: UIButton) {
        tv_message.resignFirstResponder()
        
        self.loadingStart()
        
        var body = tv_message.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let val = !tv_message.isTextValid() || body == Keys.chat_placeholder
        if val && image_path == ""{
            self.showPopup(message: "Please enter text here or select image")
            return
        }
        
        if body == Keys.chat_placeholder{
            body = ""
        }
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
        
        if image_path == ""{
            self.messages.append(Chat(body: body, senderID: switch_user.isOn ? "1" : "2", receiverID: switch_user.isOn ? "2" : "1", time: date_formatter.string(from: Date()), bodyType: "t", image: ""))
        }else{
            if body != ""{
                self.messages.append(Chat(body: body, senderID: switch_user.isOn ? "1" : "2", receiverID: switch_user.isOn ? "2" : "1", time: date_formatter.string(from: Date()), bodyType: "it", image: image_path))
            }else{
                self.messages.append(Chat(body: body, senderID: switch_user.isOn ? "1" : "2", receiverID: switch_user.isOn ? "2" : "1", time: date_formatter.string(from: Date()), bodyType: "i", image: image_path))
            }
        }
        
        tv_message.text = Keys.chat_placeholder
        tv_message.textColor = UIColor.lightGray
        tv_message.resignFirstResponder()
        selected_image = UIImage()
        image_path = ""
        
        self.tbl_chats.reloadData()
        
        self.loadingStop()
    }
    
    @IBAction func BTNRemoveImageAction(_ sender: UIButton) {
        view_image_container.isHidden = true
        image_path = ""
        selected_image = UIImage()
    }
    
}

//MARK: - TextView delegates
extension ViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        print((tv_message.contentSize.height / (tv_message.font?.lineHeight ?? 0)))
        let lines = textView.contentSize.height/(textView.font?.lineHeight)!
        print(lines)
        
//        print(textView.contentSize.height)
//        if Int(numberOfLines) > 5 {
//            self.con_height.constant = 120
//        } else {
//            if Int(numberOfLines) == 5 {
//                self.con_height.constant = textView.contentSize.height
//            }
//            self.con_height.constant = textView.contentSize.height
//        }
//        textView.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tv_message.textColor == UIColor.lightGray {
            tv_message.text = ""
            tv_message.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tv_message.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            tv_message.text = Keys.chat_placeholder
            tv_message.textColor = UIColor.lightGray
        }
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if tv_message.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
//            tv_message.text = Keys.chat_placeholder
//            tv_message.textColor = UIColor.lightGray
//        }else{
//            self.BTNSendAction(btn_send)
//        }
//        return true
//    }
}


//MARK: - Table view setup
extension ViewController:  UITableViewDelegate, UITableViewDataSource{
    
    func tableSetup(){
        tbl_chats.delegate = self
        tbl_chats.dataSource = self
        tbl_chats.register(UINib(nibName: "MessageTVC", bundle: nil), forCellReuseIdentifier: "MessageTVC")
        tbl_chats.rowHeight = UITableView.automaticDimension
        tbl_chats.estimatedRowHeight = 50 // Estimate a reasonable row height
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTVC", for: indexPath) as! MessageTVC
        let chat = messages[indexPath.row]
        print(chat)
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
        let dt = date_formatter.date(from: chat.time) ?? Date()
        
        date_formatter.dateFormat = "hh:mm:ss a"
        
        // 2 is for current user and 1 is for opposite user
        cell.img_content_me.isHidden = true
        cell.img_content.isHidden = true
        
        //        "10-Mar-2024 05:30:35 pm"
        if last_day == chat.time.formattedDate(), indexPath.row != 0{
            cell.lbl_day.isHidden = true
        }else{
            cell.lbl_day.text = chat.time.formattedDate()
            last_day = cell.lbl_day.text ?? ""
            cell.lbl_day.isHidden = false
        }
        
        
        if chat.senderID == "1"{
            cell.view_body.layer.masksToBounds = true
            cell.view_body.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            cell.view_body.layer.cornerRadius = 8
            
            cell.stack_container_me.isHidden = true
            cell.stack_container.isHidden = false
            
            cell.lbl_message.text = chat.body
            cell.lbl_time.text = date_formatter.string(from: dt)
            
            DispatchQueue.main.async {
                if let img_data = Data(base64Encoded: chat.image){
                    cell.img_content.image = UIImage(data: img_data)
                }else{
                    cell.img_content.image = UIImage(named: "ic_logo")
                }
            }
            
            if chat.bodyType.contains("i"){
                cell.img_content.isHidden = false
            }else{
                cell.img_content.isHidden = true
            }
        }else{
            cell.view_body_me.layer.masksToBounds = true
            cell.view_body_me.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            cell.view_body_me.layer.cornerRadius = 8
            
            cell.stack_container.isHidden = true
            cell.stack_container_me.isHidden = false
            
            cell.lbl_message_me.text = chat.body
            cell.lbl_time_me.text = date_formatter.string(from: dt)
            
            
            DispatchQueue.main.async {
                if let img_data = Data(base64Encoded: chat.image){
                    cell.img_content_me.image = UIImage(data: img_data)
                }else{
                    cell.img_content_me.image = UIImage(named: "ic_logo")
                }
            }
            
            if chat.bodyType.contains("i"){
                cell.img_content_me.isHidden = false
            }else{
                cell.img_content_me.isHidden = true
            }
        }
        
        cell.setNeedsLayout()
//        cell.img_content.superview?.layoutIfNeeded()
//        cell.img_content_me.superview?.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - Image Picker
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @objc func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.loadingStart()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            self.showPopup(message: "Camera error, please try again after sometime!!!")
        }
    }
    
    @objc func openGallary()
    {
        self.loadingStart()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else{
            self.showPopup(message: "Something went wrong, please try again after sometime!!!")
            return
        }
        
        selected_image = image
        image_path = image.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""//(info[.imageURL] as? URL)?.absoluteString ?? ""
        
        self.loadingStop()
    }
}
