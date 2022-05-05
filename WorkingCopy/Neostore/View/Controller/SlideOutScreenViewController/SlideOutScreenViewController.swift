//
//  SlideOutScreenViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class SlideOutScreenViewController: UIViewController {
    @IBOutlet weak var sideMenuTable: UITableView!
    lazy var viewModel: MyAccountViewModel = MyAccountViewModel()
    var viewModel2: MyCartViewModel = MyCartViewModel()
    var prodListTitle = [0,1,3,2,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuTable.register(UINib(nibName: "SideMenu", bundle: nil), forCellReuseIdentifier: "SideMenu")
        self.sideMenuTable.register(UINib(nibName: "SideMenuHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuHeader")
        sideMenuTable.delegate = self
        sideMenuTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.viewModel.webService()
        self.viewModel2.listWebService()
        setUpObservers()
    }
    func setUpObservers() {
        self.viewModel2.cartItemsListStatus.bindAndFire { (result) in
            switch result {
            case .failure(_) :
                break
            case .success:
                DispatchQueue.main.async {
                    self.sideMenuTable.reloadData()
                }
            default:
                break
            }
        }
        self.viewModel.accDetailStatus.bindAndFire { (result) in
            switch result {
            case .failure(_) :
                break
            case .success :
                DispatchQueue.main.async {
                    self.sideMenuTable.reloadData()
                }
            default:
                break
            }
        }
    }
}
extension SlideOutScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenu", for: indexPath) as! SideMenu
        if indexPath.row != 0 {
            cell.lblBadge.isHidden = true
        }
        else {
            cell.lblBadge.isHidden = false
            cell.lblBadge.text = "\(self.viewModel2.list.count)"
        }
        cell.iconImg.image = UIImage(named: "\(SideMenuIcon(rawValue: indexPath.row)!)")
        cell.lblTitle.text = "\(SideMenuName(rawValue: indexPath.row)!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.navigationController?.pushViewController(MyCartViewController.loadFromNib(), animated: true)
        case 1...4: let vc = ProductListingViewController.loadFromNib()
            vc.categoryID = "\(prodListTitle[indexPath.row])"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5: self.navigationController?.pushViewController(MyAccountViewController.loadfromNib(), animated: true)
        case 6: self.navigationController?.pushViewController(StoreLocatorViewController.loadFromNib(), animated: true)
        case 7: self.navigationController?.pushViewController(MyOrdersViewController.loadFromNib(), animated: true)
        case 8:
            UserDefaults.standard.setLoggedIn(value: false)
            UserDefaults.standard.setUserToken(value: nil)
            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginScreenViewController.loadFromNib())
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        default: break
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuHeader") as! SideMenuHeader
        let fname = self.viewModel.userContainer?.first_name ?? ""
        let lname = self.viewModel.userContainer?.last_name ?? ""
        header.lblName.text = "\(fname) \(lname)"
        header.lblEmail.text = self.viewModel.userContainer?.email ?? ""
        let img = self.viewModel.userContainer?.profile_pic ?? ""
        let url = URL(string: img)
        if let actualUrl = url {
            header.profileImg.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
        return header
    }
    
}
