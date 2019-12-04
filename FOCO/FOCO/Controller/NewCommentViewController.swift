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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Novo Comentário"
        commentView.delegate = self

        // Sets placeholder
        commentView.text = "O que mais você viu no foco?"
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
        done.tintColor = .appCoral
        bar.backgroundColor = .systemGray3
        bar.items = [spacer, done, spacer]
        bar.sizeToFit()
        commentView.inputAccessoryView = bar

        // Mocking for tests
        breedingSiteId = 6

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Activate editing when entering the view
        commentView.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func doneTapped() {
        if let content = commentView.text {
            print(content)
            // TODO: Alert is not appearing yet
            CommentServices.createComment(breedingSiteId: self.breedingSiteId ?? 0,
                                          comment: Comment(content: content)) { (error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.setupAlertController()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }

    func setupAlertController() {
        let alert = UIAlertController(title: "Seu comentário foi adicionado com sucesso!",
                                      message: "\n\n\n",
                                      preferredStyle: .alert)

        let image = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        alert.view.addSubview(image)
        setupAlertControllerConstraints(alert: alert, image: image)
        self.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
          alert.dismiss(animated: true, completion: nil)
        })
    }

    func setupAlertControllerConstraints(alert: UIAlertController, image: UIImageView) {
        // Defines Constraints for image
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: alert.view,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: alert.view,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: -8))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 64.0))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 64.0))
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
            textView.text = "O que mais você viu no foco?"
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
