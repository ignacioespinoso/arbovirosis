/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Global Constants

*/

import Foundation

let productionUrlBreedingSites: String = "https://safe-peak-03441.herokuapp.com/breeding-sites/"
let productionUrlDiseaseOccurrences = "https://safe-peak-03441.herokuapp.com/diseases/"

let devUrlBreedingSites: String = "https://arbovirosis-dev.herokuapp.com/breeding-sites/"
let devUrlDiseaseOccurrences: String = "https://arbovirosis-dev.herokuapp.com/diseases/"

let devFirebaseFilename: String = "devFile.jpg"
let prodFirebaseFilename: String = "file.jpg"

struct Messages {
    static let titleSucess = "Agradecemos o aviso"
    static let messageSucess = "Seu feedback melhora as nossas informações."

    static let failTitle = "Desculpe!"
    static let failMessage = "Não foi possível acessar os dados. Por favor, tente novamente."

    static let formsFailTitle = "Oops!"
    static let formsFailMessage = "Alguns campos obrigatórios não foram preenchidos."

    static let createdAssetTitleSuccess = "Parabéns!"
    static let createdAssetTitleSuccess2 = "Obrigado"
    static let newBreedingSiteMessageSuccess = "O foco foi adicionado e vai contribuir no combate ao vírus."
    static let newDiseaseOccurrenceMessageSuccess = "O caso foi adicionado e vai contribuir no combate ao vírus."
}
