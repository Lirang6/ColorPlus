//
//  OpeningScreen.swift
//  Color+
//
//  Created by Katie Steinmeyer on 11/13/21.
//

import UIKit

class OpeningScreen: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        // Do any additional setup after loading the view.
        directToTabController()
    }



    
    @objc func directToTabController(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller: OpeningScreen = story.instantiateViewController(identifier: "OpeningScreen") as! OpeningScreen
        let navigation = UINavigationController(rootViewController: controller)
//        UIApplication.sharedApplication().keyWindow?.rootViewController = controller
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)
        
        
        let width = self.view.frame.width / 2
        let height = self.view.frame.height / 4
        let uploadImageButton = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: width, height: height))
        let cameraImageButton = UIButton(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + 100, width: width, height: height))
        uploadImageButton.setImage(UIImage(systemName: "photo.rectangle"), for: .normal)
        cameraImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        uploadImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        cameraImageButton.addTarget(self, action: #selector(takeImage), for: .touchUpInside)
     }
    
    
    @objc func takeImage () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func uploadImage () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller
        if let image = info[.originalImage] as? UIImage {
            guard let safeStoryBoard = storyboard else {print("Storyboard not found"); return}
            let homeScreen = safeStoryBoard.instantiateViewController(withIdentifier: "ColorPaletteHomeScreen") as! ColorPaletteViewController
            homeScreen.imageContainer.image = image
            self.present(homeScreen, animated:true, completion:nil)
        }
        dismiss(animated: true, completion: nil)
    }
//    //MARK: FIRST METHOD TO OPEN NEW CONTROLLER
//    @objc func tapOnButton(){
//          let story = UIStoryboard(name: "Main", bundle: nil)
//          let controller = story.instantiateViewController(identifier: "SecondController") as! SecondController
//          self.present(controller, animated: true, completion: nil)
//      }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
