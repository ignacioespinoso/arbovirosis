/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Controller from the Breeding Site Detail Overlay Card

*/

import UIKit

class DetailControler: UIViewController {

    // MARK: - IboOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Nib Cell
        let nib = UINib.init(nibName: DetailHeaderCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DetailHeaderCell.identifier)
    }

}

// MARK: - TableView Delegate

extension DetailControler: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderCell.identifier) as? DetailHeaderCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default,
                                                                                            reuseIdentifier: "cell")
            cell?.textLabel?.text = "Row \(indexPath.row)"
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }

//        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderCell.identifier)
//                                                            as? DetailHeaderCell else {
//            return UITableViewCell()
//        }
//
//        if let detailCell = cell as? DetailHeaderCell {
//
//        }

        return cell ?? UITableViewCell()
    }

}
