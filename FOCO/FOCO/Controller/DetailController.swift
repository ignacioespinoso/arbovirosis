/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Controller from the Breeding Site Detail Overlay Card

*/

import UIKit

class DetailControler: UIViewController {

    // MARK: - Variables

    @IBOutlet weak var tableView: UITableView!

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Header Nib Cell
        let nib = UINib.init(nibName: DetailHeaderView.identifier, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: DetailHeaderView.identifier)
    }

}

// MARK: - TableView Delegate

extension DetailControler: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        if indexPath.row == 0 {
//            cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderView.identifier) as? DetailHeaderView

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default,
                                                                                            reuseIdentifier: "cell")
            cell?.textLabel?.text = "Row \(indexPath.row)"
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Dequeue with the reuse identifier
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.identifier)
            as? DetailHeaderView

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

}
