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

    var levelSelectionModels: [LevelSelectionModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainMenuCollectionView = self.view.viewWithTag(99) as! UICollectionView;
        let cellNib = UINib(nibName: "MainMenuCellView", bundle:nil)
        mainMenuCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "cvCell")
        

        mainMenuCollectionView.delegate = self
        mainMenuCollectionView.dataSource = self
        
        
        self.levelSelectionModels = [
            LevelSelectionModel( name: "Level 1", levelPath: "L1.xml"),
            LevelSelectionModel( name: "Level 2", levelPath: "L2.xml"),
            LevelSelectionModel( name: "Level 3", levelPath: "L3.xml"),
            LevelSelectionModel( name: "Level 4", levelPath: "L4.xml"),
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1  // Number of section
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.levelSelectionModels.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)

    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        
        cell.backgroundColor = UIColor.grayColor() 
        lastCellHasBackgroundColor = !lastCellHasBackgroundColor
        
        let itemIndex = Int(indexPath.row)

        let button = cell.viewWithTag(100) as! UIButton
        button.setTitle(levelSelectionModels[itemIndex].Name, forState: UIControlState.Normal);
        button.addTarget(self, action: "levelButtonPressed:", forControlEvents: .TouchUpInside)
        button.tag = itemIndex
        
        return cell
    }
    
    
    func levelButtonPressed(sender: UIButton!) {
        let levelIndex = sender.tag
        let levelModel = self.levelSelectionModels[levelIndex]
        
        let gameLevelViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GameLevelViewController") as! GameLevelViewController
        self.navigationController!.pushViewController(gameLevelViewController, animated: true)
    }
}
