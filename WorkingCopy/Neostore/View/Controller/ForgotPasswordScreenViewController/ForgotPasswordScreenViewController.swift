//
//  ForgotPasswordScreenViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class ForgotPasswordScreenViewController: UIViewController {

    //MARK:- UI Element Declaration
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    var loaderView: UIView?
    
    //MARK:- Setting up ViewController and connecting ViewModel
    lazy var viewModel: ForgotPasswordScreenViewModel = ForgotPasswordScreenViewModel()
    static func loadFromNib() -> UIViewController {
        return ForgotPasswordScreenViewController(nibName: "ForgotPasswordScreenViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK:- Calling Navigation Bar setup func
        setUpNavBar()
        
        //MARK:- Calling func to display textfield icons
        setUpImage()
        
        //MARK:- Rounded corners in button
        btnSend.layer.cornerRadius = 7
        
        txtEmail.delegate = self
        
        setUpObservers()
    }
    
    func setUpImage() {
        let emailImage = UIImage(named: Image.mail.rawValue)
        setUpTextfield(textfield: txtEmail, image: emailImage)
    }

    //MARK:- Navigation Bar title and back button
    func setUpNavBar() {
        _ = self.navigationController?.navigationBar
        navigationItem.title = "Forgot Password"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setUpObservers() {
        let email = txtEmail.text!
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
            self.showAlert(title: "Alert", message: message)
            case .success :
            self.showLoader(view: self.view, aicView: &self.loaderView)
            self.viewModel.webService(mail: email)
            default:
                break
            }
        }
        self.viewModel.mailSentStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                DispatchQueue.main.async {
                    self.showAlert(title: "Alert", message: message)
                }
            case .success (let message):
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    self.showAlert(title: "Success", message: message)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func toSendEmail(_ sender: Any) {
        let email = txtEmail.text!
        self.viewModel.validatingEmail(mail: email)
    }
    
}

extension ForgotPasswordScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        return true
    }
}
