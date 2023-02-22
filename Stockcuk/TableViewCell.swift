//
//  TableViewCell.swift
//  Stockcuk
//
//  Created by Erkan on 27.11.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelCell: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
