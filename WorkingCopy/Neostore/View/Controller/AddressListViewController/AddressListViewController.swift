//
//  AddressListViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController {
    
    @IBOutlet weak var tableviewAddressList: UITableView!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    lazy var viewModel: AddressListViewModel = AddressListViewModel()
    static func loadFromNib() -> UIViewController {
        return AddressListViewController(nibName: "AddressListViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK:- setting title to navBar
        self.navigationItem.title = "Address List"
        
        //MARK:- TableView delegate and datasource assigning
        tableviewAddressList.delegate = self
        tableviewAddressList.dataSource = self
        
        //Custom Cell Registering in main viewController
        self.tableviewAddressList.register(UINib(nibName: "AddressListCell", bundle: nil), forCellReuseIdentifier: "AddressList")
        
        setUpObservers()
        self.viewModel.webServiceForName()
        setUpNavBar()
        
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Address List"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func addBtnTapped() {
        self.navigationController?.pushViewController(AddAddressViewController.loadFromNib(), animated: true)
    }
    
    func setUpObservers(){
        //MARK:- WebService call to get name in the AddressList table view
        self.viewModel.getNameStatus.bindAndFire{ (result) in
            switch result {
            case .failure(let message):
                self.showAlert(title: "Alert", message: message)
            case .success:
                DispatchQueue.main.async {
                    self.tableviewAddressList.reloadData()
                }
            default:
                break
            }
        }
        //MARK:- To place order
        self.viewModel.placeOrderStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message):
                self.showAlert(title: "Alert", message: message)
            case .success:
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: MainHomeController())
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            default:
                break
            }
        }
    }
    
    @IBAction func placeOrderTapped(_ sender: Any) {
        self.viewModel.webService()
    }
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNoOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressList", for: indexPath) as! AddressListCell
        let address = self.viewModel.getItemAtIdx(idx: indexPath.row)
        let fname =  self.viewModel.userContainer?.first_name ?? ""
        let lname = self.viewModel.userContainer?.last_name ?? ""
        let name = "\(String(describing: fname)) \(String(describing: lname))"
        cell.configureAddressList(name: name, addressDesc: address)
        return cell
    }
    //MARK: To change image for selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.currentIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! AddressListCell
        cell.btnSelectAddress.setImage(UIImage(named: "grey_chk"), for: .normal)
    }
    //MARK: To change image for deselected row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddressListCell
        cell.btnSelectAddress.setImage(UIImage(named: "grey_unchk"), for: .normal)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}
