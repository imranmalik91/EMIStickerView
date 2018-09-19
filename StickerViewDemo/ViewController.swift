//
//  ViewController.swift
//  StickerViewDemo
//
//  Created by Imran Malik on 19/09/18.
//  Copyright © 2018 Era. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sticker = Sticker(name: "cap", sticker: #imageLiteral(resourceName: "cap"))
        createSticker(sticker: sticker)
    }

    
    fileprivate func createSticker(sticker:Sticker){
        var width = 100
        var height = 100
        
        if sticker.name == "cap" {
            width = 150
            height = 150
        }
        
        let stickerView = EmiStickerView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        stickerView.center = view.center
        stickerView.stickerImage = sticker.sticker
        view.addSubview(stickerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

