//
//  ViewController.swift
//  ChangeAvatarProject
//
//  Created by zhifu360 on 2019/5/17.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    ///创建用户头像
    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "占位图片"))
        imgView.contentMode = UIView.ContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        imgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imgView.center = self.view.center
        imgView.layer.cornerRadius = 100
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAvatar)))
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
    }

    func setPage() {
        title = "个人资料"
        view.addSubview(iconImgView)
        view.backgroundColor = RandomColor
    }

    @objc func changeAvatar() {
        AvatarManager.sharedManager.showWith(imageView: iconImgView, parentViewController: self) { [weak self] (originalImage) in
            self?.iconImgView.image = originalImage
        }
    }
    
}

