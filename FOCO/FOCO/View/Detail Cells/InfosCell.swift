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
                                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 220, height: 21))
                                        label.font = label.font.withSize(14)
                                        label.textColor = .systemGray
                                        label.textAlignment = .left
                                        label.text = "Não há imagem para esse foco :("
                                        label.center.x = self.contentView.center.x
                                        label.center.y = self.siteImage.center.y
                                        self.siteImage.addSubview(label)
                                    }
                                    self.loadingIndicator.stopAnimating()
                                    self.loadingIndicator.isHidden = true
            })
        }
    }

}
