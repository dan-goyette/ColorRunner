//
//  LevelSelectionModel.swift
//  ColorRunner
//
//  Created by Dan on 7/7/15.
//  Copyright © 2015 Dan. All rights reserved.
//

import Foundation

public class LevelSelectionModel {
    var Name : String;
    var LevelPath : String;
    
    init(name : String, levelPath: String) {
        self.Name = name;
        self.LevelPath = levelPath
    }
}