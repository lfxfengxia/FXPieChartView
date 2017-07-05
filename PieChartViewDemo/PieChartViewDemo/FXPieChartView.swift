//
//  FXPieChartView.swift
//  PieChartViewDemo
//
//  Created by 鱼米app on 2017/7/3.
//  Copyright © 2017年 LFX. All rights reserved.
//

import UIKit

class FXPieChartView: UIView {
    
    var percentAcoordingToRadius : Bool = true
    var _valueArr : [Float]?
    var valueArr : [Float] {
    
        get {
            return _valueArr!
        }
        
        set(newValue) {
            _valueArr = newValue
            initData()
        }
    }
    
    private var _dataDic : [String : Float]?
    var dataDic : [String : Float] {
        
        get {
            return _dataDic!
        }
        
        set(newValue) {
            _dataDic = newValue
            initData()
        }
    }
    
    var startDegree : Float = 0.0//可以定义开始绘制的起点
    var textArr : [NSString]?
    var maxDataNum : Float = 0.0//所有数据中的最大值
    var dataSum : Float = 0.0//数据总和
    var radius : Float = 0.0//图形半径
    var lineRadius : Float = 0.0//线半径
    let colorArr = [UIColor.init(red: 75/255.0, green: 160/255.0, blue: 235/255.0, alpha: 1.0),
                            UIColor.init(red: 253/255.0, green: 171/255.0, blue: 109/255.0, alpha: 1.0),
                            UIColor.init(red: 205/255.0, green: 100/255.0, blue: 109/255.0, alpha: 1.0),
                            UIColor.init(red: 122/255.0, green: 133/255.0, blue: 164/255.0, alpha: 1.0),
                            UIColor.init(red: 222/255.0, green: 199/255.0, blue: 15/255.0, alpha: 1.0),
                            UIColor.init(red: 134/255.0, green: 170/255.0, blue: 65/255.0, alpha: 1.0),
                            UIColor.init(red: 43/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0),
                            UIColor.init(red: 167/255.0, green: 141/255.0, blue: 214/255.0, alpha: 1.0)
                            ]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.brown
        radius = Float(min(frame.size.width * 0.25, frame.size.height * 0.25))
        lineRadius = Float(min(frame.size.width * 0.28, frame.size.height * 0.28))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - 数据初始化
    private func initData() -> Void {
        
        if let dic = _dataDic {
            
            _valueArr = Array()
            textArr = Array()
            for (key, value) in dic {
                
                textArr?.append(key as NSString)
                _valueArr?.append(value)
            }
        }
        
        if let arr = _valueArr {
            
            //数组从大到小排序
            let tmpArr = _valueArr?.sorted(by: { (v1, v2) -> Bool in
                return v1 > v2
            })
            //获取最大值
            maxDataNum = tmpArr!.first!
            //获取总和
            dataSum = arr.reduce(0, { $0 + $1})
            
            if var textArray = textArr {
                
                //textArr item添加百分比
                for i in 0 ..< arr.count {
                    
                    let percent = Float(arr[i]/dataSum) * 100
                    let percentStr = String.init(format: "%.2f", percent)
                    let text = textArray[i] as String + percentStr + "%"
                    textArray[i] = text as NSString
                }
                textArr = textArray
            }
        }
        //调用draw方法
        setNeedsDisplay()
    }
}

//MARK: - 绘制
extension FXPieChartView  {

    override func draw(_ rect: CGRect) {
        //设置开始弧度
        var endDegree = startDegree;
        //平均弧度
        let avgDegree = Float(Double.pi * 2) / Float(_valueArr!.count)
        //标注线的开始角度
        var lineStartDegree = startDegree
        
        let selfW = self.frame.size.width
        let selfH = self.frame.size.height
        
        //画扇形
        for i in 0 ..< _valueArr!.count {
            
            //求半径 半径根据比例变化的情况
            var trueRadius = _valueArr![i] / maxDataNum * radius
            if percentAcoordingToRadius == false {
                trueRadius = radius;
                endDegree = endDegree + Float(Double.pi * 2) * _valueArr![i]/dataSum;
                lineStartDegree = startDegree + (endDegree - startDegree) * 0.5;
            }else {
                endDegree = endDegree + avgDegree
                lineStartDegree = startDegree + avgDegree * 0.5
            }
            
            //画扇形
            let center = CGPoint(x: selfW * 0.5, y: selfH * 0.5)
            let context : CGContext = UIGraphicsGetCurrentContext()!//获取上下文
            context.addArc(center: center, radius: CGFloat(trueRadius), startAngle: CGFloat(startDegree), endAngle: CGFloat(endDegree), clockwise: false)//添加圆弧
            context.addLine(to: center)//添加线到中点，形成一个湖区
            
            //设置colorArr 不够时随机色填充
            var color : UIColor!
            if colorArr.count > i {
                color = colorArr[i]
            }else {
                color = UIColor(red: CGFloat(arc4random()%255) / 255.0, green: CGFloat(arc4random()%255) / 255.0, blue: CGFloat(arc4random()%255) / 255.0, alpha: 1.0)
            }
            context.setFillColor(color.cgColor)//填充颜色
            context.fillPath()//填充方式画
            
            //有标注时画线 画标注
            if let arr = textArr {
                
                //画线
                let lineHorW :CGFloat = 15.0//线的水平宽度
                
                let lineContext : CGContext = UIGraphicsGetCurrentContext()!
                let endPoint = caculateCircleCoordinateWithCenter(point: center, radius: CGFloat(lineRadius), degree: CGFloat(lineStartDegree))//获取外层半径上对应角度的点相对于self的坐标
                lineContext.move(to: center)//设置开始点
                lineContext.addLine(to: endPoint)//添加线到外层圆弧对应的坐标点
                var lineHorEndPoint : CGPoint?
                //左边水平向左 右边水平向右
                if (CGFloat(lineStartDegree) >= CGFloat(Double.pi * 1.5) || CGFloat(lineStartDegree) < CGFloat(Double.pi * 0.5)){
                    lineHorEndPoint = CGPoint(x: endPoint.x + lineHorW, y: endPoint.y)
                }else {
                    lineHorEndPoint = CGPoint(x: endPoint.x - lineHorW, y: endPoint.y)
                    
                }
                lineContext.addLine(to: lineHorEndPoint!)//继续添加线到水平结束点
                lineContext.setStrokeColor(color.cgColor)//设置线颜色
                lineContext.setLineWidth(1.0)//设置线宽
                lineContext.strokePath()//画线
                
                //画文字标注
                let text : NSString = arr[i]
                let textMaxW = selfW * 0.5 - CGFloat(lineRadius) - lineHorW//文本最大宽度
                let paragrahStyle = NSMutableParagraphStyle()
                var textStartX : CGFloat = 0.0
                
                if arr.count > i {
                    
                    //左边水平向左 右边水平向右，文字左边右对齐，右边左对齐
                    if (CGFloat(lineStartDegree) >= CGFloat(Double.pi * 1.5) || CGFloat(lineStartDegree) < CGFloat(Double.pi * 0.5)) {
                        
                        paragrahStyle.alignment = NSTextAlignment.left
                        textStartX = lineHorEndPoint!.x
                    }else {
                        
                        paragrahStyle.alignment = NSTextAlignment.right
                        textStartX = lineHorEndPoint!.x - textMaxW
                    }
                    
                    text.draw(in: CGRect.init(x: textStartX, y: lineHorEndPoint!.y - 7, width: textMaxW, height: 20), withAttributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName : UIColor.white, NSParagraphStyleAttributeName : paragrahStyle])
                }
            }
            
            startDegree = endDegree
        }
        
        //白色圆
        let whiteW : CGFloat = CGFloat(radius * 0.45)
        let whiteFrame = CGRect(x: (selfW - whiteW) * 0.5, y: (selfH - whiteW) * 0.5, width: whiteW, height: whiteW)
        
        let context1 : CGContext = UIGraphicsGetCurrentContext()!
        context1.addEllipse(in: whiteFrame)//在一个区域画椭圆，区域为正方形时画出圆
        context1.setFillColor(UIColor.white.cgColor)//设置填充色
        context1.fillPath()//填充方式画
        
        //灰色框
        let grayW : CGFloat = CGFloat(radius * 0.35)
        let grayFrame = CGRect(x: (selfW - grayW) * 0.5, y: (selfH - grayW) * 0.5, width: grayW, height: grayW)
        
        let context2 : CGContext = UIGraphicsGetCurrentContext()!
        context2.addEllipse(in: grayFrame)//设置区域为圆
        context2.setStrokeColor(UIColor.gray.cgColor)//设置线颜色
        context2.setLineWidth(1.0)//设置线宽
        context2.strokePath()//画边
        
    }
    
// MARK: - 计算圆上点相对self的坐标
    private func caculateCircleCoordinateWithCenter(point : CGPoint, radius : CGFloat, degree : CGFloat) -> CGPoint {
        
        let x = radius * cos(degree)
        let y = radius * sin(degree)
        return CGPoint(x: x + point.x, y: point.y + y)
    }
}

