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

    @objc func doneTapped() {
        if let content = commentView.text {
            print(content)
            // TODO: Alert is not appearing yet
            CommentServices.createComment(breedingSiteId: self.breedingSiteId ?? 0, comment: Comment(content: content)) { (error) in
                if error == nil {
                    let alert =  UIAlertController()
                    alert.title = "Parabéns!"
                    alert.message = "Seu comentário foi adicionado com sucesso!"
                    let okButton = UIAlertAction(title: "Continuar colaborando!", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }  else {
                    print("Some error")
                }
            }
        }
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
