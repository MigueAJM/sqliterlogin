//
//  ViewController.swift
//  login
//
//  Created by Miguel Angel Jimenez Melendez on 3/8/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {
   // @IBOutlet weak var lbnombre: UILabel!
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteLogin.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se puede acceder a la base de datos")
            return
        }else {
            let tableusuario = "Create Table If Not Exists Usuario(nombre Text, email Text Primary Key, password Text)"
            if sqlite3_exec(db, tableusuario, nil, nil, nil) != SQLITE_OK {
                alerta(title: "Error", message: "No se creo Tusuairo")
                return
            }
        }
                let sentencia = "Select email From Usuario"
                if sqlite3_prepare(db, sentencia, -1, &stmt, nil) != SQLITE_OK {
                    let error = String(cString: sqlite3_errmsg(db))
                    alerta(title: "Error", message: "Error \(error)")
                    return
                }
                
                if sqlite3_step(stmt) == SQLITE_ROW {
                    let nombre = String(cString: sqlite3_column_text(stmt, 0))
                    if nombre != "" {
                        alerta(title: "Hola", message: "Bienvenido \(nombre)")
                }else {
                   // alerta(title: "else comparacion ", message: "")
                        self.performSegue(withIdentifier: "Sregistro", sender: self)
                       }
                }else {
                   //  alerta(title: "No hay registro", message: "")
                   self.performSegue(withIdentifier: "Sregistro", sender: self)
                }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Sregistro" {
            _ = segue.destination as! ViewControllerRegistro
        }
    }
    
    func alerta (title: String, message: String){
        //Crea una alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Agrega un boton
        alert.addAction(UIAlertAction(title: "Aceptar",style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
    }

}

