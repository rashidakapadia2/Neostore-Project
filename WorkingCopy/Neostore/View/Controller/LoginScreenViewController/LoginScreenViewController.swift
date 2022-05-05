//
//  LoginScreenViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    //MARK:- UI Element Declaration
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var lblDontHaveAnAccount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var isKeyBoardExpanded: Bool = false
    var loaderView: UIView?
    
    //MARK:- Setting up ViewController and connecting ViewModel
    lazy var viewModel: LoginScreenViewModel = LoginScreenViewModel()
    static func loadFromNib() -> UIViewController {
        return LoginScreenViewController(nibName: "LoginScreenViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
    
        //MARK:- Calling func to give success or failure return statement
        setUpObservers()
        
        //MARK:- Rounded corners in button
        //btnLogin.layer.cornerRadius = 7
        txtPassword.delegate = self
        txtUsername.delegate = self
        
        //MARK:- Calling func to display textfield icons
        setUpImage()
        
        //MARK:- Calling gesture recognizers to navigate to different screens
        forgotPasswordTap()
        imgTap()
        labelTap()
        
        // Set Notification Observer for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Icon implementation on left side of textfield
    func setUpImage() {
        let nameImage = UIImage(named: Image.user.rawValue)
        let passwordImage = UIImage(named: Image.lock.rawValue)
        
        setUpTextfield(textfield: txtUsername, image: nameImage)
        setUpTextfield(textfield: txtPassword, image: passwordImage)
    }
    
    //MARK:- Implementing Tap Gesture on Forgot Password Label
    func forgotPasswordTap() {
        let fpTap = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped(_:)))
        lblForgotPassword.isUserInteractionEnabled = true
        lblForgotPassword.addGestureRecognizer(fpTap)
    }
    @objc func forgotPasswordTapped(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(ForgotPasswordScreenViewController.loadFromNib(), animated: true)
    }
    
    //MARK:- Implementing Tap Gesture on Image View of Plus
    func imgTap() {
        let imgTapped = UITapGestureRecognizer(target: self, action: #selector(imgPlusTapped(_:)))
        imgPlus.addGestureRecognizer(imgTapped)
    }
    @objc func imgPlusTapped(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(RegisterScreenViewController.loadFromNib(), animated: true)
    }
    
    //MARK:- Implementing Tap Gesture on Don't have an account Label
    func labelTap() {
        let labelTapped = UITapGestureRecognizer(target: self, action: #selector(label(_:)))
        lblDontHaveAnAccount.isUserInteractionEnabled = true
        lblDontHaveAnAccount.addGestureRecognizer(labelTapped)
    }
    @objc func label(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(RegisterScreenViewController.loadFromNib(), animated: true)
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
    
    func setUpObservers() {
        //MARK:- Textfield Validation code
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
                print(message)
            case .success:
                self.viewModel.webService()
                self.showLoader(view: self.view, aicView: &self.loaderView)
            case .none :
                break
            }
        }
        //MARK:- Login Result code on button click
        self.viewModel.loginStatus.bindAndFire { (result) in
            switch result {
            case .success :
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: MainHomeController())
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            case .failure(let message) : print(message)
                self.hideLoader(viewLoaderScreen: self.loaderView)
            case .none : break
            }
        }
    }
    
    //MARK:- Login Button Action
    @IBAction func toLogin(_ sender: Any) {
        self.view.endEditing(true)
        self.viewModel.validateUsernamePassword()
    }
}

extension LoginScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.storeData(text: textField.text, tag: textField.tag)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
}
