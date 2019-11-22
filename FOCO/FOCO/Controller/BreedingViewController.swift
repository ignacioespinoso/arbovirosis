//
//  BreedingViewController.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 21/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import MapKit

class BreedingViewController: UIViewController {

    var breeding: BreedingSite?
    var imageByte: [UInt8]?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var commentary: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var breedingImage: UIImageView!

    override func viewDidLoad() {
        name.text = breeding?.title
        commentary.text = breeding?.description
        type.text = breeding?.type
        creationDate.text = Utils.fixDateFormat(inputDate: breeding!.created)
    }

    override func viewWillAppear(_ animated: Bool) {
        BreedingSitesServices.getImageByID(breedingID: breeding!.id) { (error, image) in
            if error == nil && image != nil {
                DispatchQueue.main.async {
                    self.imageByte = image
                    let data = NSData(bytes: self.imageByte, length: self.imageByte?.count ?? 0)
                    let myImage = UIImage(data: data as Data)
                    self.breedingImage.image = myImage
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
}
