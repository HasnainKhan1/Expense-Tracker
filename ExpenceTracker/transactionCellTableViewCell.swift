//
//  transactionCellTableViewCell.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/26/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit

class transactionCellTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var amountCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
