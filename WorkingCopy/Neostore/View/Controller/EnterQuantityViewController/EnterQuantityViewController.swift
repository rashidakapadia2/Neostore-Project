//
//  EnterQuantityViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class EnterQuantityViewController: UIViewController {
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var imgCenter: LazyImageView!
    @IBOutlet weak var txtQnty: UITextField!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    var prod_ID: Int = 0
    var prod_name: String = ""
    var prod_img: String = ""
    var loaderView: UIView?
    var quantity: String = ""
    
    lazy var viewModel: EnterQuantityViewModel = EnterQuantityViewModel()
    
    static func loadFromNib() -> EnterQuantityViewController {
        return EnterQuantityViewController(nibName: "EnterQuantityViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewTap()
        self.hideLoader(viewLoaderScreen: self.loaderView)
        //MARK:- Textfield border and button attributes
        txtQnty.layer.borderWidth = 2
        btnSubmit.layer.cornerRadius = 7
        txtQnty.delegate = self
        PopUpView.layer.cornerRadius = 14
        MainView.layer.backgroundColor = UIColor.clear.cgColor
        
        setUpObservers()
        self.navigationController?.navigationBar.isHidden = true
        
        //MARK:- Setting name and image of rating pop-up
        lblProdName.text = prod_name
        let pic = prod_img
        let url = URL(string: pic)
        if let actualUrl = url {
            self.imgCenter.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
    }
    
    //MARK:- gesture recognizer on view to remove pop-up
    func viewTap() {
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(view(_:)))
        MainView.isUserInteractionEnabled = true
        MainView.addGestureRecognizer(viewTapped)
    }
    @objc func view(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- func setUpObservers
    func setUpObservers() {
        self.viewModel.validation.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                self.showLoader(view: self.view, aicView: &self.loaderView)
                self.viewModel.webService(prod_ID: self.prod_ID, qnty: Int(self.quantity) ?? 1)
            default:
                break
            }
        }
        self.viewModel.addToCartStatus.bindAndFire { (result) in
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
    
    @IBAction func submitTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.quantity = txtQnty.text ?? ""
        self.viewModel.validateQnty(qnty: quantity)
    }
}
extension EnterQuantityViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtQnty.layer.borderColor = UIColor.black.cgColor
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtQnty.layer.borderColor = UIColor.green.cgColor
    }
}
