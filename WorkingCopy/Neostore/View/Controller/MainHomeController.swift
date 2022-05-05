//
//  MainHomeController.swift
//  Neostore
//
//  Created by Neosoft on 06/04/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class MainHomeController: UIViewController {
    
    static func loadfromnib() -> UIViewController{
        return MainHomeController(nibName: "MainHomeController", bundle: nil)
    }
    
    enum Menustate {
        case opened
        case closed
    }
    
    private var menustate : Menustate = .closed
    
    let menuVC = SlideOutScreenViewController()
    let homeVC = HomeScreenViewController()
    var navVC: UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addChildVCs()
    {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        homeVC.delegate = self
        let  navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
    
}

extension MainHomeController : HomeControllerDelegate {
    func didtapmenu() {
        switch menustate {
        case .closed:
            //open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width * 0.65
            } completion: { [weak self] done in
                if done{
                    self?.menustate = .opened
                }
            }
            
        case .opened:
            //close it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done{
                    self?.menustate = .closed
                }
            }
        }
    }
}



