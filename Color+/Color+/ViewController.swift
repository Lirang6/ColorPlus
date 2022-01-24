//
//  ViewController.swift
//  Color+
//
//  Created by Liran on 10/11/2021.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    @IBOutlet var HomeView: UIView!
    @IBOutlet var imageContainer: UIImageView!
    @IBOutlet var colorPaletteContainer: UIView!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
//        createRootViewController()
//        ButtonTest.setImage(UIImage(named: "plusImg.png"), for: UIControl.State.normal)
        setDropDownMenu()
        
    }
    
//    //MARK: SECOND METHOD FOR OPEN NEW VIEW CONTROLLER IN SWIFT 5
//    @objc func createRootViewController(){
//          let story = UIStoryboard(name: "Main", bundle: nil)
//          let controller = story.instantiateViewController(identifier: "OpeningScreen") as! OpeningScreen
//          let navigation = UINavigationController(rootViewController: controller)
//          self.view.addSubview(navigation.view)
//          self.addChild(navigation)
//          navigation.didMove(toParent: self)
//     }
//
    func setDropDownMenu(){
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Photo Libary", image: UIImage(systemName: "photo"), handler: { (_) in self.importPhoto()
                }),
                UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { (_) in self.takePhoto()
                } ),
//                UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
//                })
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "Create Palette", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
//        ButtonTest.menu = demoMenu
//        ButtonTest.showsMenuAsPrimaryAction = true
    }

    func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func importPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller
        if let image = info[.originalImage] as? UIImage {
            imageContainer.image = image
            createColorPaletteView(image)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func createColorPaletteView(_ image: UIImage){
//        let colorPaletteView = ColorPaletteViewController()
//        navigationController?.pushViewController(colorPaletteView, animated: true)
//        colorPaletteView.setImg(image: image)
        //colorPaletteView.view.backgroundColor = UIColor.yellow
    }
}

