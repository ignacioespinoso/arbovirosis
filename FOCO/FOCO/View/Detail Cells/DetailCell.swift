/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Detail Cell

*/

import UIKit

class DetailCell: UITableViewCell {

    // Deixar outlet privado

    @IBOutlet weak var lblAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

}
