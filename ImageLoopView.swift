//
//  ImageLoopView.swift
//  ImageShow
//
//  Created by sea on 2016/10/18.
//  Copyright © 2016年 sea. All rights reserved.
//

import UIKit

class ImageLoopView: UIView,UIScrollViewDelegate {

    var imageSize :CGSize?
    //图片个数
    var imageNumber = 0
    var imageData :Array<String>?
    var pageCon = UIPageControl()
    
    //默认的图片视图
    var leftView  = UIImageView()
    var midView   = UIImageView()
    var rightView = UIImageView()
    //默认中间显示的图片的索引 为数组中的索引为 0 的图片
    var currentImageIndex:Int?
    
    var clickImage:((_ index: Int) -> ())?
    //let
    //重新初始化方法
    // data: 展示的图片数据组
    // size: 视图大小
    init(data:Array<String>,size:CGSize?=nil) {
        //如果不传入size大小 就先默认一个值 后面加载image时 更具image的大小设置大小
        let mySize = (size != nil) ? size : CGSize.init(width: 100, height: 100)
        super.init(frame:CGRect.init(x: 0, y: 0, width: (mySize?.width)!, height: (mySize?.height)!))
        if data.count != 0 {
            imageData = data
            imageSize = size
            imageNumber = data.count
        }else{
            print("数据为空")
        }
        currentImageIndex = 0
        self.addSubview(scrollSet())
        pageSet()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scrollView的设置
    func scrollSet() -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.frame = CGRect.init(x: 0, y: 0, width: (imageSize?.width)!, height: (imageSize?.height)!)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize.init(width: Int((imageSize?.width)!) * 3, height: Int((imageSize?.height)!))
        scrollView.setContentOffset(CGPoint.init(x: (imageSize?.width)!, y: 0), animated: false)
        
        leftView.frame  = CGRect.init(x: 0, y: 0, width: (imageSize?.width)!, height: (imageSize?.height)!)
        midView.frame   = CGRect.init(x: (imageSize?.width)!, y: 0, width: (imageSize?.width)!, height: (imageSize?.height)!)
        rightView.frame = CGRect.init(x: 2*(imageSize?.width)!, y: 0, width: (imageSize?.width)!, height: (imageSize?.height)!)
        scrollView.addSubview(leftView)
        scrollView.addSubview(midView)
        scrollView.addSubview(rightView)
        midView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(pageClick(e:)))
        midView.addGestureRecognizer(gesture)
        scrollView.setContentOffset(CGPoint.init(x: (imageSize?.width)!, y: 0), animated: false)
        loadImage(index: 1)
        return scrollView
    }

    //MARK:设置 UIPageControl
    func pageSet() {
        pageCon.numberOfPages = imageNumber
        self.addSubview(pageCon)
        
        pageCon.translatesAutoresizingMaskIntoConstraints = false
        pageCon.backgroundColor = UIColor.blue
        let width = pageCon.widthAnchor.constraint(equalToConstant: 100)
        let height = pageCon.heightAnchor.constraint(equalToConstant: 20)
        let bot   = pageCon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
        let centerX = pageCon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        NSLayoutConstraint.activate([width,height,bot,centerX])
        pageCon.layoutIfNeeded()
        
        //pageCon.addTarget(self, action: #selector(pageAction(e:)), for: UIControlEvents.valueChanged)
      //  pageCon.addTarget(self, action: #selector(pageClick(e:)), for: UIControlEvents.touchUpInside)
    }
    
    func pageAction(e:UIControlEvents) {
        print("-------\(e.rawValue)")
    }
    //点击图片
    func pageClick(e:UIGestureRecognizer) {
        clickImage!(currentImageIndex!)
    }
    //MARK:scrollView的代理 scrollView停止滑动时调整视图
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = scrollView.contentOffset.x / scrollView.bounds.size.width
        scrollView.setContentOffset(CGPoint.init(x: (imageSize?.width)!, y: 0), animated: false)
        loadImage(index: Int(pageNum))
        self.pageCon.currentPage = currentImageIndex!
    }
    //MARK:加载图片 根据当前索引 加载对应图片
    func loadImage(index:Int) {
        var leftIndex = imageNumber-1
        var rightIndex = 1
        
        //向左拉动了
        if index == 2 {
            currentImageIndex! = (currentImageIndex! + 1) % imageNumber
            leftIndex = currentImageIndex! - 1
            rightIndex = currentImageIndex! + 1
            if rightIndex >= imageNumber {
                rightIndex = 0
            }
            if leftIndex < 0 {
                leftIndex = imageNumber-1
            }
            
        }else if index == 0{
            //向左拉动了
            currentImageIndex! = (currentImageIndex! - 1) % imageNumber
            if currentImageIndex! < 0{
                currentImageIndex = imageNumber-1
            }
            leftIndex = currentImageIndex! - 1
            rightIndex = currentImageIndex! + 1
            if leftIndex < 0 {
                leftIndex = imageNumber-1
            }
            if rightIndex >= imageNumber {
                rightIndex = 0
            }
        }
        
        leftView.image  = UIImage.init(named: (imageData?[leftIndex])!)
        midView.image   = UIImage.init(named: (imageData?[currentImageIndex!])!)
        rightView.image = UIImage.init(named: (imageData?[rightIndex])!)
    }

}
