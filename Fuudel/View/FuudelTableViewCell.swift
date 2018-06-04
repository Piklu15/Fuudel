//
//  FuudelTableViewCell.swift
//  Fuudel
//
//  Created by Zert Interactive on 5/25/18.
//  Copyright © 2018 Zert Interactive. All rights reserved.
//

import UIKit
@objc protocol FuudelTableViewCellDelegate {
    func fuudelTableViewCellDidTapDelete(_ sender:FuudelTableViewCell)
     func fuudelTableViewCellDidTapCreate(_ sender:FuudelTableViewCell)
    
}
class FuudelTableViewCell: UITableViewCell {

    weak var delegate:FuudelTableViewCellDelegate?
    @IBOutlet weak var fu_title: UILabel!
    @IBOutlet weak var fu_description: UILabel!
    
    @IBOutlet weak var fu_price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var fuudel:FuudelModel? {
        didSet {
            self.fu_title.text = fuudel?.ProductName
            self.fu_description.text = fuudel?.SDetails
            self.fu_price.text = String(format:"€ %.2f",(fuudel?.Price)!)        }
    }

    @IBAction func deleteItem(_ sender: UIButton) {
        
        delegate?.fuudelTableViewCellDidTapDelete(self)
        
    }
    @IBAction func createItem(_ sender: UIButton) {
        delegate?.fuudelTableViewCellDidTapCreate(self)

        print("create item")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
