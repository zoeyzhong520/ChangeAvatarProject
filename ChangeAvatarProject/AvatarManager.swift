//
//  AvatarManager.swift
//  ChangeAvatarProject
//
//  Created by zhifu360 on 2019/5/17.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class AvatarManager: NSObject {

    static let sharedManager = AvatarManager()
    
    fileprivate var parentViewController: UIViewController!
    
    var completionBlock: ((_ image: UIImage?) -> Void)?
    
    ///UIImagePickerController对象
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = AvatarManager.sharedManager
        return picker
    }()
    
    ///创建相册、拍照选择弹框
    func showWith(imageView: UIImageView, parentViewController: UIViewController, completion: @escaping ((_ image: UIImage?) -> Void)) {
        self.parentViewController = parentViewController
        completionBlock = completion
        
        let alert = UIAlertController(title: "更换头像", message: nil, preferredStyle: UIDevice.isIpad() ? .alert : .actionSheet)
        alert.addAction(UIAlertAction(title: "相册选取", style: .default, handler: { (cancelAction) in
            self.openPhotoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (confirmAction) in
            self.takePhoto()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        parentViewController.present(alert, animated: true, completion: nil)
    }
    
    ///打开相册
    func openPhotoLibrary() {
        photoLibraryAuthorizationStatus()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            parentViewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    ///拍照
    func takePhoto() {
        cameraAuthorizationStatus()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            parentViewController.present(imagePicker, animated: true, completion: nil)
        } else {
            UIAlertView(title: "提示", message: "该设备相机不可用", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    ///相册访问权限
    func photoLibraryAuthorizationStatus() {
        if SystemVersion < 11 {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .restricted || status == .denied {
                //无权限
                //提示前往授权
                statusAlertWith(message: "请打开设置-隐私-照片以允许访问设备相册") {
                    if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
                return
            }
        }
    }
    
    ///相机访问权限
    func cameraAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            //无权限
            //提示前往授权
            statusAlertWith(message: "请打开设置-隐私-照片以允许访问设备相机") {
                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            return
        }
    }
    
    func statusAlertWith(message: String?, completion: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "前往设置", style: .default, handler: { (confirmAction) in
            completion()
        }))
        parentViewController.present(alert, animated: true, completion: nil)
    }
    
}

extension AvatarManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取图片
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if completionBlock != nil {
            completionBlock!(originalImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
