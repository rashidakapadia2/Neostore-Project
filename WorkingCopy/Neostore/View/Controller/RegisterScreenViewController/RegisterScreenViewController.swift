//
//  RegisterScreenViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class RegisterScreenViewController: UIViewController {
    
    //MARK:- UI Element Declaration
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    var isKeyBoardExpanded: Bool = false
    @IBOutlet weak var scrollView: UIScrollView!
    var loaderView: UIView?
    
    //MARK:- Setting up ViewController and connecting ViewModel
    lazy var viewModel: RegisterScreenViewModel = RegisterScreenViewModel()
    static func loadFromNib() -> UIViewController {
        return RegisterScreenViewController(nibName: "RegisterScreenViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        //MARK:- setting title to navBar
        self.navigationItem.title = "Register"
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtEmail.delegate = self
        txtPhoneNumber.delegate = self
        
        //MARK:- func call for adding icons to textfields
        setUpImage()
        
        //MARK:- Calling func to give success or failure return statement
        setUpObservers()
        
        //MARK:- Rounded corners in button
        btnRegister.layer.cornerRadius = 7
        
        //MARK:- Calling NavBar setup func
        setUpNavBar()
        
        // Set Notification Observer for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Leftside icons for textfields
    func setUpImage() {
        let nameImage = UIImage(named: Image.user.rawValue)
        let emailImage = UIImage(named: Image.mail.rawValue)
        let passwordImage = UIImage(named: Image.unlock.rawValue)
        let confPassImage = UIImage(named: Image.lock.rawValue)
        let phoneImage = UIImage(named: Image.phone.rawValue)
        
        setUpTextfield(textfield: txtFirstName, image: nameImage)
        setUpTextfield(textfield: txtLastName, image: nameImage)
        setUpTextfield(textfield: txtEmail, image: emailImage)
        setUpTextfield(textfield: txtPassword, image: passwordImage)
        setUpTextfield(textfield: txtConfirmPassword, image: confPassImage)
        setUpTextfield(textfield: txtPhoneNumber, image: phoneImage)
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
    
    //MARK:- Navigation Bar title and back button
    func setUpNavBar() {
        _ = self.navigationController?.navigationBar
        navigationItem.title = "Register"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK:- func setUpObservers
    func setUpObservers() {
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success:
                self.showLoader(view: self.view, aicView: &self.loaderView)
                self.viewModel.webService()
            default:
                break
            }
        }
        self.viewModel.registrationStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    self.navigationController?.pushViewController(LoginScreenViewController.loadFromNib(), animated: true)
                }
            default:
                break
            }
        }
    }
    
    //MARK:- Register Button Action
    @IBAction func toRegister(_ sender: Any) {
        self.view.endEditing(true)
        self.viewModel.validateTextFields()
    }
    
    //MARK:- Radio button implementing func
    func radioBtnTapped(_ isBtnMaleSelected: Bool) {
        if isBtnMaleSelected {
            self.btnMale.isSelected = true
            self.btnFemale.isSelected = false
        }
        else {
            self.btnMale.isSelected = false
            self.btnFemale.isSelected = true
        }
    }
    
    //MARK:- Radio button implementation for Gender
    @IBAction func radioBtnMaleTapped(_ sender: Any) {
        radioBtnTapped(true)
    }
    @IBAction func radioBtnFemaleTapped(_ sender: Any) {
        radioBtnTapped(false)
    }
    
    //MARK:- Checkbox func implementation
    @IBAction func checkboxTapped(_ : UIButton) {
        if checkbox.isSelected {
            checkbox.isSelected = false
        }
        else {
            checkbox.isSelected = true
        }
    }
    
    //MARK:- Adding icons to the left of textfields
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage ) {
        let leftImageView = UIImageView(frame: CGRect(x: 5.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
}

extension RegisterScreenViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.storeData(text: textField.text, tag: textField.tag)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
        return true
    }
}
