/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Protocol Reusable set variable identifier as the Class name.
Used in TableView for Xib identidier

*/

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {

    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {

}
