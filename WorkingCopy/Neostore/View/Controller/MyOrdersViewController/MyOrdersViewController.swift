//
//  MyOrdersViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {
    @IBOutlet weak var MyOrderTableView: UITableView!
    var loaderView: UIView?
    
    lazy var viewModel: MyOrdersViewModel = MyOrdersViewModel()
    static func loadFromNib() -> UIViewController {
        return MyOrdersViewController(nibName: "MyOrdersViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:-
        MyOrderTableView.delegate = self
        MyOrderTableView.dataSource = self
        
        //MARK:- Registering Custom Cell and nib
        MyOrderTableView.register(UINib(nibName: "MyOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrder")
        
        //MARK:- Calling webServices
        self.viewModel.webService()
        setUpObservers()
        self.showLoader(view: self.view, aicView: &self.loaderView)
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- setting up NabBar
        setUpNavBar()
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MY ORDERS"
    }
    
    func setUpObservers() {
        self.viewModel.orderListStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message):
                self.showAlert(title: "Alert", message: message)
            case .success:
                DispatchQueue.main.async {
                    self.hideLoader(viewLoaderScreen: self.loaderView)
                    self.MyOrderTableView.reloadData()
                }
            default:
                break
                
            }
        }
    }
}
extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrder", for: indexPath) as! MyOrdersTableViewCell
        let order = self.viewModel.getItemAtIndexAt(idx: indexPath.row)
        
        cell.configureOrderList(orderID: order.id ?? 0, desc: order.created ?? "", price: order.cost ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderIDViewController.loadFromNib() as! OrderIDViewController
        let order = self.viewModel.getItemAtIndexAt(idx: indexPath.row)
        vc.order_id = order.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
