/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Detail Cell

*/

import UIKit

class DetailCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var siteImage: UIImageView!
    @IBOutlet weak private var siteAddress: UILabel!
    @IBOutlet weak var siteDescription: UILabel!
    @IBOutlet weak var addCommentBtn: UIButton!
    @IBOutlet weak var reportSiteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        // This should make cell proper for auto-layout
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

}
