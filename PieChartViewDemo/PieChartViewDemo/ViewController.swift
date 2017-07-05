//
//  ViewController.swift
//  PieChartViewDemo
//
//  Created by 鱼米app on 2017/7/3.
//  Copyright © 2017年 LFX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pieView = FXPieChartView(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: view.frame.size.width * 0.8))
//        pieView.valueArr = [10,19,23,25,8,20,15,12] //设置该属性 没有标注 
        pieView.dataDic = ["英国" : 10,"美国" : 19,"中国" : 23,"韩国" : 25,"日本" : 8,"德国" : 20,"西班牙" : 15,"葡萄牙" : 12]//设置国家名称以及对应的实际数据，不是所占比例（设置该属性有标注）
//        pieView.percentAcoordingToRadius = false;//true 效果图1 false 效果图2 默认为true
        pieView.colorArr = [UIColor.init(red: 75/255.0, green: 160/255.0, blue: 235/255.0, alpha: 1.0),
                            UIColor.init(red: 253/255.0, green: 171/255.0, blue: 109/255.0, alpha: 1.0),
                            UIColor.init(red: 205/255.0, green: 100/255.0, blue: 109/255.0, alpha: 1.0),
                            UIColor.init(red: 122/255.0, green: 133/255.0, blue: 164/255.0, alpha: 1.0),
                            UIColor.init(red: 222/255.0, green: 199/255.0, blue: 15/255.0, alpha: 1.0),
                            UIColor.init(red: 134/255.0, green: 170/255.0, blue: 65/255.0, alpha: 1.0),
                            UIColor.init(red: 43/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0),
                            UIColor.init(red: 167/255.0, green: 141/255.0, blue: 214/255.0, alpha: 1.0)
        ]//不设置颜色 默认为随机色
        
        view.addSubview(pieView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

