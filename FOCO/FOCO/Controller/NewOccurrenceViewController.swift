//
//  NewOccurrenceViewController.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 19/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import UIKit
import Eureka

class NewOccurrenceViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Dados do Paciente")
            <<< TextRow { row in
                row.title = "Nome"
            }
            <<< TextRow { row in
                row.title = "Início dos sintomas*"
            }

        +++ Section("Informações do Caso")
            <<< TextRow { row in
                row.title = "Doença"
            }
            <<< SwitchRow { row in
                row.title = "Confirmado por médico*"
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
