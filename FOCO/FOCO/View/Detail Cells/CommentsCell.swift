/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Comments Cell

*/

import UIKit

class CommentsCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentCreatedDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // This should make cell proper for auto-layout
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    // MARK: - SetUps



}
