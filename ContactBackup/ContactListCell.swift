//
//  ContactListCell.swift
//  ContactBackup
//
//

import UIKit

class ContactListCell: UITableViewCell {

    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var ProfilePick: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
