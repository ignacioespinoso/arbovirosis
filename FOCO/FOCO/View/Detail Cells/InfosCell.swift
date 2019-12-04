/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Breeding Site Infos Cell

Prototype Cell direct in Storyboard

*/

import UIKit
import MapKit
import AlamofireImage

class InfosCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var siteImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

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

        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()

        if let breedingPic = site.imageURL {
//            siteImage.af_setImage(withURL: breedingPic)
            siteImage.af_setImage(withURL: breedingPic,
                                  placeholderImage: nil,
                                  filter: nil,
                                  progress: nil,
                                  progressQueue: DispatchQueue.main,
                                  imageTransition: UIImageView.ImageTransition.noTransition,
                                  runImageTransitionIfCached: false,
                                  completion: { _ in // response
                                    self.loadingIndicator.stopAnimating()
                                    self.loadingIndicator.isHidden = true
            })
        }
    }

}
