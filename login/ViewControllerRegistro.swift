//
//  ViewControllerRegistro.swift
//  login
//
//  Created by Miguel Angel Jimenez Melendez on 3/8/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewControllerRegistro: UIViewController {
    @IBOutlet weak var txtnom: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpsw: UITextField!
    @IBOutlet weak var txtpsw2: UITextField!
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
        // Do any additional setup after loading the view.
    }
    @IBAction func btnlogin(_ sender: UIButton) {
        if txtnom.text!.isEmpty || txtemail.text!.isEmpty || txtpsw.text!.isEmpty || txtpsw.text!.isEmpty {
            alerta(title: "Falta Informaciòn", message: "Complete el formulario")
            txtnom.becomeFirstResponder()
        } else {
            let nombre = txtnom.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let email = txtemail.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let psw = txtpsw.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let query = "Insert Into Usuario(nombre, email, password) Values(?, ?, ?)"
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error al ligar insert")
                return
            } else {
                if sqlite3_bind_text(stmt, 1, nombre.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "nombre")
                    return
                }
                if sqlite3_bind_text(stmt, 2, email.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "email ")
                    return
                }
                if sqlite3_bind_text(stmt, 3, psw.utf8String, -1, nil) != SQLITE_OK {
                    alerta(title: "Error", message: "password")
                    return
                }
                if sqlite3_step(stmt) != SQLITE_OK {
                    self.performSegue(withIdentifier: "Slogin", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Slogin" {
            _ = segue.destination as! ViewController
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
}
