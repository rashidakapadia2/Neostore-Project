//
//  RatingPopUpViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class RatingPopUpViewController: UIViewController {

    @IBOutlet var MainView: LazyImageView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var imgCenter: LazyImageView!
    @IBOutlet weak var btnRateNow: UIButton!
    @IBOutlet weak var btnStar1: UIButton!
    @IBOutlet weak var btnStar2: UIButton!
    @IBOutlet weak var btnStar3: UIButton!
    @IBOutlet weak var btnStar4: UIButton!
    @IBOutlet weak var btnStar5: UIButton!
    var prod_ID: Int = 0
    var prod_name: String = ""
    var prod_img: String = ""
    var loaderView: UIView?
    
    lazy var viewModel: RatingPopUpViewModel = RatingPopUpViewModel()
    static func loadfromNib() -> RatingPopUpViewController {
        return RatingPopUpViewController(nibName: "RatingPopUpViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        viewTap()
        self.hideLoader(viewLoaderScreen: self.loaderView)
        //MARK:- Textfield border and button attributes
        btnRateNow.layer.cornerRadius = 7
        popUpView.layer.cornerRadius = 7
        setUpObservers()
        popUpView.layer.cornerRadius = 14
        
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
                self.viewModel.webService(prod_ID: "\(self.prod_ID)", rating: self.currentRating)
            default:
                break
            }
        }
    self.viewModel.ratingStatus.bindAndFire { (result) in
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
    var currentRating: Int = 0
    @IBAction func star1Tapped(_ sender: Any) {
        currentRating = 1
        rating(1)
    }
    @IBAction func star2Tapped(_ sender: Any) {
        currentRating = 2
        rating(2)
    }
    @IBAction func star3Tapped(_ sender: Any) {
        currentRating = 3
        rating(3)
    }
    @IBAction func star4Tapped(_ sender: Any) {
        currentRating = 4
        rating(4)
    }
    @IBAction func star5Tapped(_ sender: Any) {
        currentRating = 5
        rating(5)
    }
    func rating(_ n : Int){
        btnStar1.setImage((n>=1 ? UIImage(named: Icons.starFull.rawValue) : UIImage(named: Icons.starEmpty.rawValue)), for: .normal)
        btnStar2.setImage((n>=2 ? UIImage(named: Icons.starFull.rawValue) : UIImage(named: Icons.starEmpty.rawValue)), for: .normal)
        btnStar3.setImage((n>=3 ? UIImage(named: Icons.starFull.rawValue) : UIImage(named: Icons.starEmpty.rawValue)), for: .normal)
        btnStar4.setImage((n>=4 ? UIImage(named: Icons.starFull.rawValue) : UIImage(named: Icons.starEmpty.rawValue)), for: .normal)
        btnStar5.setImage((n>=5 ? UIImage(named: Icons.starFull.rawValue) : UIImage(named: Icons.starEmpty.rawValue)), for: .normal)
    }
    
    @IBAction func rateNowTapped(_ sender: Any) {
        view.endEditing(true)
        self.viewModel.validateRating(rating: currentRating)
    }
}
