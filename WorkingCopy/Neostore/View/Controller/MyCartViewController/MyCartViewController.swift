//
//  MyCartViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController {
    @IBOutlet weak var tableviewMyCart: UITableView!
    @IBOutlet weak var btnOrderNow: UIButton!
    var selectedRow = 0
        let screenWidth = UIScreen.main.bounds.width - 60
        let screenHeight = UIScreen.main.bounds.height / 3
    let quantity = [1,2,3,4,5,6,7,8]
    
    lazy var viewModel: MyCartViewModel = MyCartViewModel()
    static func loadFromNib() -> UIViewController {
        return MyCartViewController(nibName: "MyCartViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK:- Rounded corners in button
        btnOrderNow.layer.cornerRadius = 7
        navigationItem.title = "My Cart"
        
        //MARK:- TableView delegate and datasource assigning
        tableviewMyCart.delegate = self
        tableviewMyCart.dataSource = self
        
        //MARK:- Registering tableView cell and footer
        self.tableviewMyCart.register(UINib(nibName: "MyCartCell", bundle: nil), forCellReuseIdentifier: "MyCart")
        self.tableviewMyCart.register(UINib(nibName: "ReusableFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        
        //MARK:- Setting Up Observers and calling api for cart items
        setUpObservers()
        self.viewModel.listWebService()
        setUpNavBar()
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "My Cart"
    }
    //MARK:- Setting Up Observers
    func setUpObservers(){
        self.viewModel.cartItemsListStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success:
                DispatchQueue.main.async {
                    self.tableviewMyCart.reloadData()
                }
            default:
                break
            }
        }
        self.viewModel.editCartStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success :
                self.viewModel.listWebService()
            default:
                break
            }
        }
        self.viewModel.deleteCartItemsStatus.bindAndFire { (result) in
            switch result {
            case .failure(let message) :
                self.showAlert(title: "Alert", message: message)
            case .success:
                self.viewModel.listWebService()
            default:
                break
            }
        }
    }
    
    //MARK:- MyCart page below button
    @IBAction func orderNowTapped(_ sender: Any) {
        self.navigationController?.pushViewController(AddressListViewController.loadFromNib(), animated: true)
    }
}

extension MyCartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNoOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCart", for: indexPath) as! MyCartCell
        let list = self.viewModel.list[indexPath.row].product
        let qnty = self.viewModel.list[indexPath.row].quantity!
        print("llllll")
        print(qnty)
        cell.configureCartList(name: list?.name ?? "", desc: list?.product_category ?? "", price: list?.cost ?? 0, qnty: qnty , img: list?.product_images ?? "")
        
        cell.selectionDelegate = self
        cell.id = list?.id ?? 0
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 67
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer") as! ReusableFooter
        let totalCost = self.viewModel.totalCost
        footer.lblTotalPrice.text = "\(totalCost)"
        if totalCost == 0 {
            footer.isHidden = true
            btnOrderNow.isUserInteractionEnabled = false
            btnOrderNow.layer.opacity = 0.3
        }
        else {
            footer.isHidden = false
            btnOrderNow.isUserInteractionEnabled = true
            btnOrderNow.layer.opacity = 1
        }
        return footer
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let del = self.viewModel.list[indexPath.row].product_id
            self.viewModel.deleteWebService(prod_id: del ?? 0)
            completion(true)
        }
        let img = UIImage(named: "delete")!
        deleteAction.image = img
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
extension MyCartViewController: editQntyDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    func PickAQuantity(num: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        
        let alert = UIAlertController(title: "Update Quantity", message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] (UIAlertAction) in
            if let updatedQuantityNum = self?.selectedRow {
                self?.viewModel.editWebService(prod_id: num, qnty: updatedQuantityNum)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(quantity[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row + 1
    }
}
