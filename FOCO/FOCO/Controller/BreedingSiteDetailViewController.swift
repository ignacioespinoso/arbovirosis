/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Controller from the Breeding Site Detail Overlay Card

*/

import UIKit

class BreedingSiteDetailViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Variables

    // Populated from perfomSegue
    var site: BreedingSite?
    var comments: [Comment] = []

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Header Nib Cell
        let nib = UINib.init(nibName: DetailHeaderView.identifier, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: DetailHeaderView.identifier)

        // Comment Nib
        let nib2 = UINib.init(nibName: CommentsCell.identifier, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: CommentsCell.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500

        let antevere = Comment(content: "oooooo")
        self.comments.append(antevere)
    }

}

// MARK: - TableView Delegate

extension BreedingSiteDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.comments.count + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: InfosCell.identifier) as? InfosCell

            if let detailCell = cell as? InfosCell {
                detailCell.setLabels(withSite: self.site!)
            }

        case 1...self.comments.count:
            cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.identifier) as? CommentsCell

            if let commentCell = cell as? CommentsCell {
                // IndexPath for this array starts at 1
                commentCell.setLabels(forComment: self.comments[indexPath.row - 1])
            }

        default:
            fatalError("Could Not Find Row")
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Dequeue with the reuse identifier
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.identifier)
            as? DetailHeaderView

        // Remove Optional
        if let breedingSite = site {
            header?.setLabels(withSite: breedingSite)
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

}
