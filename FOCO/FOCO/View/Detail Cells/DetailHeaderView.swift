/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Header for Detail

*/

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlets

    @IBOutlet weak private var siteTitle: UILabel!
    @IBOutlet weak private var siteCreatedTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // This should make cell proper for auto-layout
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    // MARK: - SetUps

    func setLabels(withSite site: BreedingSite) {
        self.siteTitle.text = site.title
        self.siteCreatedTime.text = "Criado em: " + Utils.fixDateFormat(inputDate: site.created!)
    }

}
