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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var commentary: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var address: UILabel!

    override func viewDidLoad() {
        name.text = breeding?.title
        commentary.text = breeding?.description
        type.text = breeding?.type
        creationDate.text = Utils.fixDateFormat(inputDate: breeding!.created)
    }
}
