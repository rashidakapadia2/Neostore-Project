//
//  HomeScreenViewController.swift
//  Neostore
//
//  Created by Neosoft on 16/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate: AnyObject {
    func didtapmenu()
}

class HomeScreenViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    private var timer: Timer!
    var noOfSecs: Int = 0
    
    let imagesArray = [ "slider_img1","slider_img2","slider_img3","slider_img4"]
    
    weak var delegate: HomeControllerDelegate?
    var collection: UICollectionView?
    
    //MARK:- Setting up ViewController and connecting ViewModel
    lazy var viewModel: HomeScreenViewModel = HomeScreenViewModel()
    static func loadFromNib() -> UIViewController {
        return HomeScreenViewController(nibName: "HomeScreenViewController", bundle: nil)
    }
    
    let cellArray = ["tableicon","sofaicon","chairsicon","cupboardicon"]
    
    let HomeCell = "ImageCell"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
        //MARK:- Scroll Timer
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCell)
        //MARK:- to flip images on pagecontrol
        scrollView.delegate = self
        pageController.addTarget(self, action: #selector(pageValueChanged(_:)), for: .valueChanged)
        //MARK:- setting up images on scroll view
        for i in 0..<imagesArray.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: imagesArray[i])
            let xPos = CGFloat (i)*self.view.bounds.size.width
            imageView.frame = CGRect (x: xPos, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.contentSize.width = view.frame.size.width*CGFloat(i+1)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.addSubview(imageView)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    @objc func timerRunning() {
        if self.noOfSecs < self.imagesArray.count-1 {
                    noOfSecs += 1
                }
                else{
                    self.noOfSecs = 0
                }
        scrollView.setContentOffset(CGPoint(x: CGFloat(noOfSecs) * view.frame.size.width, y: 0), animated: true)
    }
    //MARK:- pageControl add target func
    @objc func pageValueChanged(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    //MARK:- changing pagecontrol dots on scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageController.numberOfPages = imagesArray.count
        pageController.currentPage = Int(page)
    }
    
    //MARK:- Navigation Bar title and back button
    func setUpNavBar() {
        navigationItem.title = "NeoSTORE"
        let menuBtn = UIBarButtonItem(image: UIImage(named: Icons.menu.rawValue), style: .plain, target: self, action: #selector(menuBtnTapped))
        self.navigationItem.leftBarButtonItem = menuBtn
        let searchBtn = UIBarButtonItem(image: UIImage(named: Icons.search.rawValue), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    @objc func menuBtnTapped(){
        delegate?.didtapmenu()
    }
}

extension HomeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell, for: indexPath) as! ImageViewCell
        
        cell.cellImg.image = UIImage(named: cellArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 12)/2
        let cellHeight = (collectionView.frame.size.height - 12)/2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductListingViewController.loadFromNib()
        vc.categoryID = self.viewModel.gettingCategoryID(idx: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


