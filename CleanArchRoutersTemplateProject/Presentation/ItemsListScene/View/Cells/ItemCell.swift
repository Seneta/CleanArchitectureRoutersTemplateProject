//
//  ItemCell.swift
//  CleanArchRoutersTemplateProject
//
//  Created by User6 on 12/20/19.
//  Copyright © 2019 User6. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(_ item: UIItemData) {
        titleLabel.text = item.title
    }
    
}
