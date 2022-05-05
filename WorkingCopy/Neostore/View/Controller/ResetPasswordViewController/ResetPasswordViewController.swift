//
//  ResetPasswordViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //MARK:- UI Element Declaration
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var isKeyBoardExpanded: Bool = false
    var loaderView: UIView?
    
    lazy var viewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    static func loadFromNib() -> UIViewController {
        return ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        //MARK:- setUpNavBar
        setUpNavBar()

        //MARK:- Rounded corners in button
        btnResetPassword.layer.cornerRadius = 7
        
        setUpImage()
        setUpObservers()
        
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtCurrentPassword.delegate = self
        
        // Set Notification Observer for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Setting up nav bar
    func setUpNavBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Reset Password"
    }
    
    //MARK:- ScrollView height for keyboard appearing
    @objc func keyboardAppeared(_ notification: Notification) {
        if !isKeyBoardExpanded {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height + keyboardHeight)
                isKeyBoardExpanded = true
            }
        }
    }
    //MARK:- ScrollView height for keyboard disappearing
    @objc func keyboardDisappeared(_ notification: Notification) {
        if isKeyBoardExpanded {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height - keyboardHeight)
                isKeyBoardExpanded = false
            }
        }
    }
    
    //MARK:- Setting Up Observers
    func setUpObservers() {
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success:
                self.viewModel.webService()
                self.showLoader(view: self.view, aicView: &self.loaderView)
            default:
                break
            }
        }
        self.viewModel.changePassStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                break
            }
        }
    }
    
    func setUpImage() {
        let passImage = UIImage(named: Image.unlock.rawValue)
        let cPassImage = UIImage(named: Image.lock.rawValue)
        
        setUpTextfield(textfield: txtCurrentPassword, image: cPassImage)
        setUpTextfield(textfield: txtNewPassword, image: passImage)
        setUpTextfield(textfield: txtConfirmPassword, image: cPassImage)
    }

    //MARK:- Reset Password Button Action
    @IBAction func toResetPassword(_ sender: Any) {
        self.viewModel.validateTextFields()
    }
}

extension ResetPasswordViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.storeData(text: textField.text, tag: textField.tag)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCurrentPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        return true
    }
}
