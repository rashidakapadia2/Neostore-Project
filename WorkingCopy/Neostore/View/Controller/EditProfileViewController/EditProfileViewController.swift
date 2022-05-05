//
//  EditProfileViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //MARK:- UI Element Declaration
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    let datePicker = UIDatePicker()
    var isKeyBoardExpanded: Bool = false
    var loaderView: UIView?
    var pp: String = ""
    
    //MARK:- Connecting View and ViewModel
    lazy var viewModel: EditProfileViewModel = EditProfileViewModel()
    static func loadFromNib() -> UIViewController {
        return EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
        //MARK:- Textfield Delegate
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtNumber.delegate = self
        txtDOB.delegate = self
        
        //MARK:- setUpNavBar
        setUpNavBar()
        
        //MARK:- Rounded corners in button
        btnSubmit.layer.cornerRadius = 7
        imgPic.layer.borderWidth = 2
        imgPic.layer.masksToBounds = false
        imgPic.layer.borderColor = UIColor.white.cgColor
        imgPic.layer.cornerRadius = imgPic.frame.size.height/2
        imgPic.clipsToBounds = true
        
        //MARK:- Calling functions
        setUpImage()
        setUpObservers()
        createDatePicker()
        
        //MARK:- Gesture Recognizer on imgView to pick image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped(gestureRecognizer: )))
        imgPic.addGestureRecognizer(tapGesture)
        imgPic.isUserInteractionEnabled = true
        
        // Set Notification Observer for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    //MARK:- DatePicker
    func createDatePicker(){
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        txtDOB.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValChanged(_:)), for: .valueChanged)
    }
    
    //MARK:- setting up navigation bar
    func setUpNavBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Edit Profile"
    }
    
    //MAK:- ImagePicker on gesture recognizer call
    @objc func imgTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.showLoader(view: self.view, aicView: &self.loaderView)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
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
    
    //MARK:- setting Up Observers
    func setUpObservers() {
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success:
                let img = self.imgPic.image ?? UIImage(named: "placeholder")
                self.pp = convertImageToBase64String(img: img! )
                self.viewModel.webService()
                self.showLoader(view: self.view, aicView: &self.loaderView)
            default:
                break
            }
        }
        self.viewModel.userUpdateStatus.bindAndFire { (result) in
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
    @objc func datePickerValChanged(_ sender: UIDatePicker) {
        txtDOB.text = dateToString(curDate: datePicker.date)
    }
    
    // Convert Date into string
    func dateToString(curDate: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        return dateFormater.string(from: curDate)
    }
    
    //MARK:- Adding left icons to textfields
    func setUpImage() {
        let nameImage = UIImage(named: Image.user.rawValue)
        let emailImage = UIImage(named: Image.mail.rawValue)
        let phoneImage = UIImage(named: Image.phone.rawValue)
        let DOBImage = UIImage(named: Image.birthday.rawValue)
        
        setUpTextfield(textfield: txtFirstName, image: nameImage)
        setUpTextfield(textfield: txtLastName, image: nameImage)
        setUpTextfield(textfield: txtEmail, image: emailImage)
        setUpTextfield(textfield: txtNumber, image: phoneImage)
        setUpTextfield(textfield: txtDOB, image: DOBImage)
    }
    
    //MARK:- Submit Button Action
    @IBAction func toSubmit(_ sender: Any) {
        self.view.endEditing(true)
        self.viewModel.validateTextfields()
    }
}

//MARK:- Textfield delegate method to pass data to viewModel
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.storeData(text: textField.text, tag: textField.tag)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtDOB.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtNumber.resignFirstResponder()
        return true
    }
}

//MARK:- Image Picker implementation
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.hideLoader(viewLoaderScreen: self.loaderView)
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgPic.image = imagePicker
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.hideLoader(viewLoaderScreen: self.loaderView)
        picker.dismiss(animated: true, completion: nil)
    }
}
