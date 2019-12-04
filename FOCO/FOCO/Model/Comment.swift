//
//  Comment.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 04/12/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation

struct Comment: Codable {

    let id: CLong
    let content: String?
    let created: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case created = "created"
    }

    init(content: String?) {
        // Para efeito de POST, o parâmetro id precisa ser 0
        self.id = 0
        self.content = content
        self.created = nil
    }
}
