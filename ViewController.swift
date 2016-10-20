//
//  ViewController.swift
//  ImageShow
//
//  Created by sea on 2016/10/18.
//  Copyright © 2016年 sea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageSize = CGSize.init(width: self.view.bounds.width, height: 100.0)
        let a = ImageLoopView.init(data: ["icon_01.png","icon_02.png","icon_03.png","icon_04.png","icon_05.png"], size: imageSize)
        self.view.addSubview(a)
        a.clickImage = { index in
            print("当前点击的图片：\(index)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

