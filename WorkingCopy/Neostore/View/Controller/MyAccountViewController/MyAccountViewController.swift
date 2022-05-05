//
//  MyAccountViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    //MARK:- UI Element Declaration
    @IBOutlet weak var imgProfilePic: LazyImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    var loaderView: UIView?
    
    lazy var viewModel: MyAccountViewModel = MyAccountViewModel()
    static func loadfromNib() -> UIViewController {
        return MyAccountViewController(nibName: "MyAccountViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- setUpNavBar
        setUpNavBar()
        
        //MARK:- Rounded corners in button
        btnEditProfile.layer.cornerRadius = 7
        imgProfilePic.layer.borderWidth = 2
        imgProfilePic.layer.masksToBounds = false
        imgProfilePic.layer.borderColor = UIColor.white.cgColor
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.height/2
        imgProfilePic.clipsToBounds = true
        
        setUpImage()
        setUpObservers()
        self.viewModel.webService()
        self.showLoader(view: self.view, aicView: &self.loaderView)
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "My Account"
    }
    func setUpImage() {
//        let fnameImage = UIImage(named: Image.user.rawValue)
//        addLeftView(fnameImage)
//        
//        let lnameImage = UIImage(named: Image.user.rawValue)
//        let emailImage = UIImage(named: Image.mail.rawValue)
//        let passwordImage = UIImage(named: Image.unlock.rawValue)
//        let confPassImage = UIImage(named: Image.lock.rawValue)
//        let phoneImage = UIImage(named: Image.phone.rawValue)
    }
    
    func setUpObservers(){
        self.viewModel.accDetailStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async { [self] in
                    let user = self.viewModel.userContainer
                    self.lblFirstName.text = user?.first_name ?? ""
                    self.lblLastName.text = user?.last_name ?? ""
                    self.lblEmail.text = user?.email ?? ""
                    self.lblDOB.text = user?.dob ?? "\(Date())"
                    self.lblPhoneNumber.text = user?.phone_no ?? ""
                    let url = URL(string: user?.profile_pic  ?? "")
                    if let actualUrl = url {
                        self.imgProfilePic.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
                    }
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                }
            default:
                break
            }
        }
    }

    //MARK:- Edit Profile Button Action
    @IBAction func toEditProfile(_ sender: Any) {
        self.navigationController?.pushViewController(EditProfileViewController.loadFromNib(), animated: true)
    }
    
    //MARK:- Reset Profile Button Action
    @IBAction func toResetProfile(_ sender: Any) {
        self.navigationController?.pushViewController(ResetPasswordViewController.loadFromNib(), animated: true)
    }
}
