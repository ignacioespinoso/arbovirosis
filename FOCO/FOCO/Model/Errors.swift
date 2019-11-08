/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Error types
 
*/

import UIKit

enum Errors : Error {
    
    case databaseFailure
    case clientFailure
    case serverError
}


/*
 
 import UIKit

 enum MyError: Error {
     case Error1
     case Error2(String, Int)
     case Error3
 }

 let a = MyError.Error1
 let b = MyError.Error2("Uma mensagem ou qualuqr outra coisa",7)


 if case  MyError.Error2(let value, let count) = b {
     print("Erro 2 com valor \"\(value)\" e contagem \(count)")
 }

 
 
 
 */
