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

        getComments()

        self.tableView.separatorStyle = .none
    }

    func getComments() {
        if let breedingSite = site {
            CommentServices.findAllCommentsByBreedingSiteId(breedingSiteId: breedingSite.id) { (error, allComments) in
                if error == nil, let messages = allComments {
                    self.comments = messages
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error in Comments")
                }
            }
        }
    }

    // From New Comments
    @IBAction func unwindToSiteDetail(_ unwindSegue: UIStoryboardSegue) {
        self.getComments()
        self.tableView.reloadData()
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
                detailCell.reportDelegate = self
                detailCell.addNewCommentDelegate = self
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

    // MARK: TableView Header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Dequeue with the reuse identifier
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.identifier)
            as? DetailHeaderView

        // Remove Optional
        if let breedingSite = site {
            header?.setLabels(withSite: breedingSite)
            header?.dismissDelegate = self
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    // MARK: TableView Report Actions

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var allowEditing: Bool = true

        // First Info Detail Cell cannot be eddited
        if indexPath.row == 0 {
            allowEditing = false
        }

        return allowEditing
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal,
                                      title: title,
                                      handler: { (_, _, completionHandler) in // action, sourceView

            Utils.setupReportAlertController(viewController: self,
                                             isComment: true,
                                             completion: {
                CommentServices.reportComment(breedingSiteId: self.site!.id,
                                              commentId: self.comments[indexPath.row - 1].id) { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            Utils.setupAlertControllerWithTitle(viewController: self,
                                                                title: Messages.titleSucess,
                                                                message: Messages.messageSucess,
                                                                systemImage: "checkmark.circle",
                                                                color: .appMediumElectricBlue,
                                                                timer: nil,
                                                                completion: {})
                        }
                        print("Comment reported successfully")
                    } else {
                        DispatchQueue.main.async {
                            Utils.setupAlertControllerWithTitle(viewController: self,
                                                                title: Messages.failTitle,
                                                                message: Messages.failMessage,
                                                                systemImage: "checkmark.circle",
                                                                color: .appCoral,
                                                                timer: nil,
                                                                completion: {})
                        }
                        print("Comment report failed")
                    }
                }
            })

            completionHandler(true)
        })

        action.image = UIImage(named: "Reportar+Symbol")
        action.backgroundColor = .appCoral
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
      return .none
    }

}

    // MARK: - Buttons Delegates

extension BreedingSiteDetailViewController: ReportBtnDelegate {

    // BreedingSitesServices only if user clicks on report
    func reportBreedingSite(forId id: Int) {
        let titleSucess = "Agradecemos o aviso"
        let messageSucess = "Seu feedback melhora as nossas informações."

        let failTitle = "Desculpe!"
        let failMessage = "Não foi possível acessar os dados. Por favor, tente novamente."

        Utils.setupReportAlertController(viewController: self,
                                         isComment: false,
                                         completion: {
            BreedingSitesServices.reportSite(breedingSiteId: id) { (error) in
                if error == nil {
                    DispatchQueue.main.async {
                        Utils.setupAlertControllerWithTitle(viewController: self,
                                                            title: titleSucess,
                                                            message: messageSucess,
                                                            systemImage: "checkmark.circle",
                                                            color: .appMediumElectricBlue,
                                                            timer: nil,
                                                            completion: {})

                    }
                    print("Comment reported successfully")
                } else {
                    DispatchQueue.main.async {
                        Utils.setupAlertControllerWithTitle(viewController: self,
                                                            title: failTitle,
                                                            message: failMessage,
                                                            systemImage: "xmark.octagon",
                                                            color: .appCoral,
                                                            timer: nil,
                                                            completion: {})
                    }
                    print("Comment report failed")
                }
                                            }
        })

    }

}

extension BreedingSiteDetailViewController: AddNewCommentBtnDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newComment":
            if let vc = segue.destination as? NewCommentViewController {
                vc.breedingSiteId = self.site?.id
            }

        default:
            print("None of those segues")
        }
    }

    func addNewComment(forSite siteId: Int) {
        performSegue(withIdentifier: "newComment", sender: nil)
    }

}

extension BreedingSiteDetailViewController: DismissBtnDelegate {

    func dissmissViewController() {
        self.dismiss(animated: true,
                     completion: nil)
    }

}
