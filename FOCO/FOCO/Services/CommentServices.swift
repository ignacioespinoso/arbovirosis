//
//  CommentServices.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 04/12/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation

class CommentServices {

    // MARK: Get Comment Array

    static func findAllCommentsByBreedingSiteId(breedingSiteId: Int, _ completion: @escaping (_ errorMessage: Error?,
                                                     _ comments: [Comment]?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        CommentDAO.findAllCommentsByBreedingSiteId(breedingSiteId: breedingSiteId, { (error, comments) in
            if error != nil {
                // Handle errors
                print("Unable to retrieve comments")
                print(error.debugDescription)
            } else {
                completion(nil, comments)
            }
        })
    }

    // MARK: - Post Comment

    static func createComment (breedingSiteId: Int,
                               comment: Comment,
                               _ completion: @escaping (_ error: Error?) -> Void ) {

        var jsonData: Data?
        do {
            jsonData = try JSONEncoder().encode(comment)
        } catch let myJSONError {
            print(myJSONError)
        }

        CommentDAO.createComment(breedingSiteId: breedingSiteId, jsonData: jsonData) { (error, commendId) in

            if error != nil {
                // Handle errors
                print("Unable to create comment")
                print(error.debugDescription)
                completion(error)
            } else {
                if let id = commendId {
                    print("Comment ID \(id) created.")
                    completion(nil)
                }
            }
        }
    }
}
