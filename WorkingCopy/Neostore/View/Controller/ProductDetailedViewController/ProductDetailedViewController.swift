//
//  ProductDetailedViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class ProductDetailedViewController: UIViewController {
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblProdPrice: UILabel!
    @IBOutlet weak var prodImg: LazyImageView!
    @IBOutlet weak var prodCollectionView: UICollectionView!
    @IBOutlet weak var txtViewProdDescription: UITextView!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    
    @IBOutlet weak var lblProd_Name: UILabel!
    @IBOutlet weak var lblProd_Description: UILabel!
    @IBOutlet weak var lblProd_Place: UILabel!
    @IBOutlet var ratingStars: [UIImageView]!
    
    var loaderView: UIView?
    var rate: Int = 0
    var category_id: Int = 0
    @IBOutlet weak var lblOutOfStock: UILabel!
    var prodID: Int?
    var product_Images: [ProductImage]? = []
    
    lazy var viewModel: ProductDetailedViewModel = ProductDetailedViewModel()
    static func loadFromNib() -> ProductDetailedViewController {
        return ProductDetailedViewController(nibName: "ProductDetailedViewController", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- Assigning attributes and font
        btnRate.layer.cornerRadius = 7
        btnBuyNow.layer.cornerRadius = 7
        txtViewProdDescription.isEditable = false
        txtViewProdDescription.isScrollEnabled = false
        //MARK:- Calling NavBar setup func
        setUpNavBar()
        self.hideLoader(viewLoaderScreen: self.loaderView)
        setUpObservers()
        self.viewModel.webService(prodID: prodID ?? 0)
        //MARK:- Collection View delegate, datasource and registering custom cells
        prodCollectionView.delegate = self
        prodCollectionView.dataSource = self
        prodCollectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    //MARK:- Navigation Bar title, back button and search button
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = getTitle(categoryID: category_id)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let searchBtn = UIBarButtonItem(image: UIImage(named: Icons.search.rawValue), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    //MARK:- SetUp Observers
    func setUpObservers() {
        self.viewModel.productDetailStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async {
                    let prod = self.viewModel.product_detail
                    self.configureProducts(name: prod?.name ?? "", desc: "Category - \(self.getTitle(categoryID: prod?.productCategoryID ?? 1))", title: prod?.producer ?? "", rating: prod?.rating ?? 5, price: prod?.cost ?? 0, description: prod?.dataDescription ?? "")
                    self.product_Images = prod?.productImages
                    self.prodCollectionView.reloadData()
                    let img = self.viewModel.product_detail?.productImages?[0].image ?? ""
                    let url = URL(string: img)
                    if let actualUrl = url {
                        self.prodImg.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
                    }
                }
            default:
                break
            }
        }
    }
    //MARK:- To get names of categories from category ID
    func getTitle(categoryID: Int) -> String {
        if categoryID == 1 {
            return "Tables"
        }
        else if categoryID == 2 {
            return "Chairs"
        }
        else if categoryID == 3 {
            return "Sofas"
        }
        else {
            return "Cupboards"
        }
    }
    //MARK:- Configure Products
    func configureProducts(name: String, desc: String, title: String, rating: Int, price: Int, description: String ) {
        lblProd_Name.text = name
        lblProd_Description.text = desc
        lblProd_Place.text = title
        rate = rating
        lblProdPrice.text = "Rs.\(price)"
        txtViewProdDescription.text = description
        displayRating(rate: rate)
    }
    //MARK:- func to display rating
    func displayRating(rate: Int) {
        for i in 1...5 {
            if i <= rate {
                ratingStars[i-1].image = UIImage(named: Icons.starFull.rawValue)
            }
            else {
                ratingStars[i-1].image = UIImage(named: Icons.starEmpty.rawValue)
            }
        }
    }
    
    //MARK:- Button Tapped func
    @IBAction func buyNowTapped(_ sender: Any) {
        let vc = EnterQuantityViewController.loadFromNib()
        vc.prod_ID = self.viewModel.product_detail?.id ?? 0
        vc.prod_name = self.viewModel.product_detail?.name ?? ""
        vc.prod_img = self.viewModel.product_detail?.productImages?[0].image ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
        self.showLoader(view: self.view, aicView: &self.loaderView)
    }
    //MARK:- Button Tapped func
    @IBAction func rateNowTapped(_ sender: Any) {
        let vc = RatingPopUpViewController.loadfromNib()
        vc.prod_ID = self.viewModel.product_detail?.id ?? 0
        vc.prod_name = self.viewModel.product_detail?.name ?? ""
        vc.prod_img = self.viewModel.product_detail?.productImages?[0].image ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
        self.showLoader(view: self.view, aicView: &self.loaderView)
    }
    //MARK:- Button Tapped func
    @IBAction func shareBtnTapped(_ sender: Any) {
        let prod = self.viewModel.product_detail
        let items = [prod?.name]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
}
extension ProductDetailedViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.product_detail?.productImages?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        let img = self.viewModel.product_detail?.productImages?[indexPath.row].image ?? ""
        let url = URL(string: img)
        if let actualUrl = url {
            cell.cellImg.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MARK:- Assigning image to the center img view on selection
        let img = self.viewModel.product_detail?.productImages?[indexPath.row].image ?? ""
        let url = URL(string: img)
        if let actualUrl = url {
            prodImg.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
        //MARK:- Changing border color on selection
        let cell : UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 2
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell : UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
    }
}
