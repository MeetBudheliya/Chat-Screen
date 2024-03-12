//
//  MessageTVC.swift
//  Chat Screen
//
//  Created by Meet Budheliya on 11/03/24.
//

import UIKit

class MessageTVC: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var stack_container_me: UIStackView!
    @IBOutlet weak var stack_container: UIStackView!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var lbl_message_me: UILabel!
    @IBOutlet weak var view_body: UIView!
    @IBOutlet weak var view_body_me: UIView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_time_me: UILabel!
    @IBOutlet weak var img_content: UIImageView!
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var img_content_me: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
