//
//  AuthViewController.swift
//  MoneyCounter
//
//  Created by Stanislav on 28.04.2020.
//  Copyright © 2020 Stanislav. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import RealmSwift

class AuthViewController: UIViewController {
    
    var signUp: Bool = true {
        willSet {
            if newValue {
                signUpMode()
            } else {
                signInMode()
            }
        }
    }
    
    var waste: Waste?
    var userID: UserID?
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var loginfield: UITextField!
    
    @IBOutlet weak var passwordfield: UITextField!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var namefield: UITextField!
    
    @IBOutlet weak var loadindicator: UIActivityIndicatorView!
    @IBOutlet weak var surnamelabel: UILabel!
    @IBOutlet weak var surnamefield: UITextField!
    
    @IBOutlet weak var haveregistr: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadindicator.stopAnimating()
    }
    
    
    @IBAction func changeForm(_ sender: Any) {
        signUp = !signUp
    }
    
    
    func signInMode() {
        namefield.isHidden = true
        surnamefield.isHidden = true
        namelabel.isHidden = true
        surnamelabel.isHidden = true
        titlelabel.text = "Вход"
        haveregistr.setTitle("Зарегистрироваться", for: .normal)
    }
    
    func signUpMode() {
        namefield.isHidden = false
        surnamefield.isHidden = false
        namelabel.isHidden = false
        surnamelabel.isHidden = false
        titlelabel.text = "Регистрация"
        haveregistr.setTitle("Уже зарегистрированы?", for: .normal)
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Все поля должны быть заполнены", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func SIGNIN(_ sender: Any) {
        
        let name = namefield.text!
        let surname = surnamefield.text!
        let email = loginfield.text!
        let password = passwordfield.text!
        
        if signUp == true {
            if name.isEmpty || email.isEmpty || password.isEmpty || surname.isEmpty {
                showAlert()
            }
            else {
                self.loadindicator.startAnimating()
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard result != nil, (error == nil) else { return print("error is \(error)") }
                    
                    let ref = Database.database().reference().child("users")
                    ref.child((result?.user.uid)!).updateChildValues(["name" : name, "surname" : surname, "email" : email])
                    /*let date = Date()
                    let calendar = Calendar.current
                    let d = calendar.component(.day, from: date)
                    let m = calendar.component(.month, from: date)
                    let y = calendar.component(.year, from: date)
                    //self.userID = UserID(id: (result?.user.uid)!, day: "\(d)",month: "\(m)", year: "\(y)",goal: "Продукты", amount: "1200")
                    //print("\((result?.user.uid)!)")
                    //DBManager.saveID(self.userID!)*/
                    //self.waste = Waste(id: (result?.user.uid)!, day: "",month: "", year: "",goal: "", amount: "")
                    self.userID = UserID(id: (result?.user.uid)!)
                    DBManager.saveID(self.userID!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        else {
            if email.isEmpty || password.isEmpty {
                showAlert()
            } else {
                self.loadindicator.startAnimating()
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    guard result != nil, (error == nil) else { return }
                    
                    self.loadindicator.stopAnimating()
                    self.userID = UserID(id: (result?.user.uid)!)
                    DBManager.saveID(self.userID!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}

