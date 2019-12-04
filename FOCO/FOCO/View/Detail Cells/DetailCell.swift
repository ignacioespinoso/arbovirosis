/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Detail Cell

*/

import UIKit
import MapKit
import AlamofireImage

class DetailCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var siteImage: UIImageView!
    @IBOutlet weak private var siteAddress: UILabel!
    @IBOutlet weak private var siteAccessType: UILabel!
    @IBOutlet weak private var siteDescription: UILabel!
    @IBOutlet weak private var addCommentBtn: UIButton!
    @IBOutlet weak private var reportSiteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        // This should make cell proper for auto-layout
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    // MARK: - SetUps

    func setLabels(withSite site: BreedingSite) {

        getImage(fromSite: site)
        getAddress(fromSite: site)
        self.siteAccessType.text = site.type
        self.siteDescription.text = site.description
    }

    // MARK: - Aux

    func getAddress(fromSite site: BreedingSite) {
        let breedingLocation = CLLocation(latitude: site.latitude,
                                          longitude: site.longitude)
        Utils.getAddressText(coordinate: breedingLocation) { (addressTxt, error) in
            if error == nil {
                self.siteAddress.text = addressTxt
            } else {
                print(error as Any)
            }
        }
    }

    func getImage(fromSite site: BreedingSite) {
        if let breedingPic = site.imageURL {
            siteImage.af_setImage(withURL: breedingPic)
        }
    }

}
