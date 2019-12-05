/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Breeding Site Infos Cell

Prototype Cell direct in Storyboard

*/

import UIKit
import MapKit
import AlamofireImage

protocol ReportBtnDelegate: NSObjectProtocol {
    func reportBreedingSite(forId id: Int)
}

protocol AddNewCommentBtnDelegate: NSObjectProtocol {
    func addNewComment(forSite siteId: Int)
}

class InfosCell: UITableViewCell {

    // MARK: - Outlets

    var siteId: Int = 0
    @IBOutlet weak private var siteImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var siteAddress: UILabel!
    @IBOutlet weak private var siteAccessType: UILabel!
    @IBOutlet weak private var siteDescription: UILabel!

    weak var reportDelegate: ReportBtnDelegate?
    weak var addNewCommentDelegate: AddNewCommentBtnDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.font = self.label.font.withSize(14)
        self.label.textColor = .systemGray
        self.label.textAlignment = .left
        self.label.text = "Não há imagem para esse foco :("
        self.siteImage.addSubview(self.label)
        // This should make cell proper for auto-layout
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    // MARK: - SetUps

    func setLabels(withSite site: BreedingSite) {
        self.label.isHidden = true
        getImage(fromSite: site)
        self.label.center.x = self.contentView.center.x
        self.label.center.y = self.siteImage.center.y
        getAddress(fromSite: site)
        self.siteAccessType.text = site.type
        self.siteDescription.text = site.description
        self.siteId = site.id
    }

    // MARK: - Buttons

    @IBAction func addNewComment(_ sender: Any) {
        addNewCommentDelegate?.addNewComment(forSite: self.siteId)
    }

    @IBAction func reportSite(_ sender: UIButton) {
        reportDelegate?.reportBreedingSite(forId: self.siteId)
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
        self.label.isHidden = true
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()

        if let breedingPic = site.imageURL {
            siteImage.af_setImage(withURL: breedingPic,
                                  placeholderImage: nil,
                                  filter: nil,
                                  progress: nil,
                                  progressQueue: DispatchQueue.main,
                                  imageTransition: UIImageView.ImageTransition.noTransition,
                                  runImageTransitionIfCached: false,
                                  completion: { response in
                                    // If no breeding site has no image, adds a label.
                                    if response.value == nil {
                                        self.label.isHidden = false
                                    } else {
                                        self.label.isHidden = true
                                    }
                                    self.loadingIndicator.stopAnimating()
                                    self.loadingIndicator.isHidden = true
            })
        }
    }

}
