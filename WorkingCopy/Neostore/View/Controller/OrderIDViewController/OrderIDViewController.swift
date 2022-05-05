//
//  OrderIDViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class OrderIDViewController: UIViewController {
    @IBOutlet weak var tableviewOrderID: UITableView!
    var order_id: Int = 0
    
    lazy var viewModel: OrderIDViewModel = OrderIDViewModel()
    static func loadFromNib() -> UIViewController {
        return OrderIDViewController(nibName: "OrderIDViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:- TableView Delegate, Datasource
        tableviewOrderID.delegate = self
        tableviewOrderID.dataSource = self
        //MARK:- Registering tableViewCell & footer
        tableviewOrderID.register(UINib(nibName: "ReusableTableViewCell", bundle: nil), forCellReuseIdentifier: "Reuse")
        tableviewOrderID.register(UINib(nibName: "ReusableFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        //MARK:- Calling webServices
        setUpObservers()
//        print("ID : \(order_id)")
        self.viewModel.webService(order_id: "\(order_id)")
        //MARK:- setUpNavbar
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setUpNavBar()
    }
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "ORDER ID : \(String(describing: order_id))"
    }
    
    func setUpObservers() {
        self.viewModel.orderIDStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message):
                self.showAlert(title: "Alert", message: message)
            case .success:
                print("OrderDetails printed")
                DispatchQueue.main.async {
                    self.tableviewOrderID.reloadData()
                }
            default:
                break
                
            }
        }
    }
}

extension OrderIDViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath) as! ReusableTableViewCell
        let orderDetail = self.viewModel.getItemAtIndexAt(idx: indexPath.row)
        cell.configureList(name: orderDetail.prodName , desc: orderDetail.prodCatName , price: orderDetail.total , qnty: orderDetail.quantity , img: orderDetail.prodImage )
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer") as! ReusableFooter
        footer.lblTotalPrice.text = "\(self.viewModel.totalCost)"
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 87
    }
}
