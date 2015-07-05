//
//  MainMenuViewController.swift
//  ColorRunner
//
//  Created by Dan on 7/5/15.
//  Copyright © 2015 Dan. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellReuseIdentifier = "cvCell"
    //private var mainMenuCollectionView : UICollectionView
    var lastCellHasBackgroundColor = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainMenuCollectionView = self.view.viewWithTag(99) as! UICollectionView;
        let cellNib = UINib(nibName: "MainMenuCellView", bundle:nil)
        mainMenuCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "cvCell")
        

        mainMenuCollectionView.delegate = self
        mainMenuCollectionView.dataSource = self
        
        
        //mainMenuCollectionView.addSubview(self.collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
//        return cell
//    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        // Select operation
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        // Configure the cell
        // 3
        cell.backgroundColor = lastCellHasBackgroundColor ? UIColor.redColor() : UIColor.blueColor()
        lastCellHasBackgroundColor = !lastCellHasBackgroundColor
        
        let label = cell.viewWithTag(100) as! UILabel
        label.text = "x" + String(indexPath.row)
        
        return cell
    }

    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView : UICollectionReusableView? = nil
//        
//        // Create header
//        if (kind == UICollectionElementKindSectionHeader) {
//            // Create Header
//            var headerView : PackCollectionSectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kCellheaderReuse, forIndexPath: indexPath) as PackCollectionSectionView
//            
//            reusableView = headerView
//        }
//        return reusableView!
//    }
}
