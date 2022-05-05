//
//  ProductListingViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class ProductListingViewController: UIViewController {
    
    var productModel: ProductData?
    var categoryID: String?
    var loaderView: UIView?
    
    @IBOutlet weak var productListTable: UITableView!
    
    lazy var viewModel: ProductListingViewModel = ProductListingViewModel()
    
    static func loadFromNib() -> ProductListingViewController {
        return ProductListingViewController(nibName: "ProductListingViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader(view: self.view, aicView: &self.loaderView)
        setUpObservers()
        self.viewModel.webService(categoryId: categoryID ?? "")
        
        //MARK:- TableView delegate and datasource assigning
        productListTable.delegate = self
        productListTable.dataSource = self
        
        //Custom Cell Registering in main viewController
        self.productListTable.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellReuseIdentifier: "Product")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- Calling NavBar setup func
        setUpNavBar()
        self.hideLoader(viewLoaderScreen: self.loaderView)
    }
    
    //MARK:- Navigation Bar title, back button and search button
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = getTitle(categoryID: Int(categoryID ?? "") ?? 0)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let searchBtn = UIBarButtonItem(image: UIImage(named: Icons.search.rawValue), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    
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
    
    //MARK:- func setUpObservers
    func setUpObservers() {
        self.viewModel.productListStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    self.productListTable.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension ProductListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalNumOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as! ProductViewCell
        let product = self.viewModel.getItemAtIndexAt(idx: indexPath.row)
        
        // Configure Product
        let productName = product.name ?? ""
        let productProducer = product.producer ?? ""
        let productRating = product.rating ?? 0
        let productCost = product.cost ?? 0
        let productImg = product.productImages ?? ""
        
        cell.configureProductsList(name: productName, desc: productProducer , price: productCost, rating: productRating, img: productImg)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK:- sending id to Product Detailed VC
        self.showLoader(view: self.view, aicView: &self.loaderView)
        let vc = ProductDetailedViewController.loadFromNib()
        let product = self.viewModel.getItemAtIndexAt(idx: indexPath.row)
        vc.prodID = product.id ?? 0
        vc.category_id = product.productCategoryID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
