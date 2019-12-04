/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Header for Detail

*/

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView {

    // Deixar outlet privado

    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true

    }

}
