//
//  NewCommentViewController.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 04/12/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import UIKit

class NewCommentViewController: UIViewController, UITextViewDelegate {

    var breedingSiteId: Int?

    @IBOutlet weak var commentView: UITextView!

    // MARK: - Variables

    let unwindToBreendingSiteDetails: String = "unwindToSiteDetail"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "O que mais você sabe sobre esse foco?"
        commentView.delegate = self

        // Sets placeholder
        commentView.text = "Ex. Entrei em contato com a prefeitura, mas acho que devemos fazer um mutirão na área."
        commentView.textColor = UIColor.lightGray

        // Adds gesture recognizer to help manage keyboard behaviour
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(DismissKeyboard))
        commentView.addGestureRecognizer(tap)

        // Adds done button above the keyboard
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Postar",
                                   style: .plain,
                                   target: self,
                                   action: #selector(doneTapped))

        done.tintColor = .appDarkImperialBlue
        done.setTitleTextAttributes([
                                    NSAttributedString.Key.font: UIFont(name: "SFProText-Medium", size: 20)!,
                                    NSAttributedString.Key.foregroundColor: UIColor.appDarkImperialBlue
                                    ],
                                    for: .normal)

        bar.barTintColor = .systemActionSheetBackground

        bar.items = [spacer, done, spacer]
        bar.sizeToFit()
        commentView.inputAccessoryView = bar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Activate editing when entering the view
        commentView.becomeFirstResponder()
    }

    @objc func doneTapped() {
        if let content = commentView.text {
            // Uploads comment to the API
            CommentServices.createComment(breedingSiteId: self.breedingSiteId ?? 0,
                                          comment: Comment(content: content)) { (error) in
                if error == nil {
                    // Show alert if comment was posted successfully
                    DispatchQueue.main.async {
                        Utils.setupAlertController(viewController: self,
                                                   message: "Seu comentário foi adicionado com sucesso!",
                                                   systemImage: "checkmark.circle",
                                                   timer: 1.15,
                                                   completion: {
                                                    self.performSegue(withIdentifier: self.unwindToBreendingSiteDetails,
                                                                      sender: nil)
                        })
                    }
                } else {
                    Utils.setupAlertController(viewController: self,
                                                message: "Erro ao adicionar o comentário",
                                                systemImage: "xmark.octagon",
                                                color: .red,
                                                timer: 1.15,
                                                completion: {
                                                    self.performSegue(withIdentifier: self.unwindToBreendingSiteDetails,
                                                                      sender: nil)
                    })
                    print(error!.localizedDescription)
                }
            }
        }
    }

    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true,
                     completion: nil)
    }

}

// MARK: UITextViewDelegate
extension NewCommentViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Removes placeholder
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Reset placeholder if necessary
        if textView.text.isEmpty {
            textView.text = "Ex. Entrei em contato com a prefeitura, mas acho que devemos fazer um mutirão na área."
            textView.textColor = UIColor.lightGray
        }
    }

    @objc func DismissKeyboard() {
        // Causes the view to resign from the status of first responder.
        if commentView.isFirstResponder {
            commentView.resignFirstResponder()
        } else {
            commentView.becomeFirstResponder()
        }
    }
}
