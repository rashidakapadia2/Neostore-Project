//
//  AddAddressViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {

    @IBOutlet weak var txtViewAddress: UITextView!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCityMain: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnSaveAddress: UIButton!
    
    lazy var viewModel: AddAddressViewModel = AddAddressViewModel()
    static func loadFromNib() -> UIViewController {
        return AddAddressViewController(nibName: "AddAddressViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        btnSaveAddress.layer.cornerRadius = 7
        
        //MARK:- setting title to navBar
        self.navigationItem.title = "Add Address"
        
        //MARK:- Textfield delegates
        txtCityMain.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        txtCountry.delegate = self
        txtZipCode.delegate = self
        txtViewAddress.delegate = self
        
        setUpObservers()
        setUpNavBar()
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Add Address"
    }
    
    func setUpObservers() {
        self.viewModel.validation.bindAndFire{ (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async {
                    self.viewModel.fullAddress()
                    self.navigationController?.pushViewController(AddressListViewController.loadFromNib(), animated: true)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func saveAddressTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.viewModel.validateTextFields()
    }
}

extension AddAddressViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.storeData(text: textField.text, tag: textField.tag)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.viewModel.storeData(text: textView.text, tag: textView.tag)
    }
}
